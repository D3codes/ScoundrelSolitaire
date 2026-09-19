//
//  ControllerInputMonitor.swift
//  Scoundrel
//

import Foundation
import GameController
import SwiftUI

enum ControllerInput: Equatable {
    case up
    case down
    case left
    case right
    case primary
    case secondary
    case menu
}

struct ControllerInputOccurrence: Equatable {
    let id = UUID()
    let input: ControllerInput
}

@MainActor
final class ControllerInputMonitor: ObservableObject {
    @Published private(set) var occurrence: ControllerInputOccurrence?
    @Published private(set) var isControllerConnected = false

    private var observers: [NSObjectProtocol] = []
    private var configuredControllers: [GCController] = []
    private var directionalStates: [ObjectIdentifier: (horizontal: Int, vertical: Int)] = [:]

    func startMonitoring() {
        guard observers.isEmpty else { return }

        observers = [
            NotificationCenter.default.addObserver(
                forName: .GCControllerDidConnect,
                object: nil,
                queue: .main
            ) { [weak self] notification in
                guard let controller = notification.object as? GCController else { return }
                Task { @MainActor in self?.configure(controller) }
            },
            NotificationCenter.default.addObserver(
                forName: .GCControllerDidDisconnect,
                object: nil,
                queue: .main
            ) { [weak self] notification in
                guard let controller = notification.object as? GCController else { return }
                Task { @MainActor in self?.remove(controller) }
            }
        ]

        GCController.controllers().forEach(configure)
        updateConnectionState()
    }

    func stopMonitoring() {
        observers.forEach(NotificationCenter.default.removeObserver)
        observers.removeAll()
        configuredControllers.forEach(clearHandlers)
        configuredControllers.removeAll()
        directionalStates.removeAll()
        isControllerConnected = false
    }

    private func configure(_ controller: GCController) {
        guard !configuredControllers.contains(controller) else { return }
        configuredControllers.append(controller)
        updateConnectionState()

        if let gamepad = controller.extendedGamepad {
            configure(gamepad.dpad, for: controller)
            configure(
                gamepad.leftThumbstick,
                for: controller,
                invertVertical: ProcessInfo.processInfo.isMacCatalystApp
            )
            configure(gamepad.buttonA, as: .primary)
            configure(gamepad.buttonB, as: .secondary)
            configure(gamepad.buttonMenu, as: .menu)
        } else if let gamepad = controller.microGamepad {
            configure(gamepad.dpad, for: controller)
            configure(gamepad.buttonA, as: .primary)
            configure(gamepad.buttonX, as: .secondary)
            configure(gamepad.buttonMenu, as: .menu)
        }
    }

    private func configure(
        _ directionPad: GCControllerDirectionPad,
        for controller: GCController,
        invertVertical: Bool = false
    ) {
        directionPad.valueChangedHandler = { [weak self, weak controller] _, xValue, yValue in
            guard let controller else { return }
            Task { @MainActor in
                self?.handleDirection(
                    x: xValue,
                    y: invertVertical ? -yValue : yValue,
                    from: controller
                )
            }
        }
    }

    private func configure(_ button: GCControllerButtonInput, as input: ControllerInput) {
        button.pressedChangedHandler = { [weak self] _, _, isPressed in
            guard isPressed else { return }
            Task { @MainActor in self?.send(input) }
        }
    }

    private func handleDirection(x: Float, y: Float, from controller: GCController) {
        let identifier = ObjectIdentifier(controller)
        let oldState = directionalStates[identifier] ?? (0, 0)
        let newHorizontal = x > 0.5 ? 1 : x < -0.5 ? -1 : 0
        let newVertical = y > 0.5 ? 1 : y < -0.5 ? -1 : 0

        if newHorizontal != 0 && newHorizontal != oldState.horizontal {
            send(newHorizontal > 0 ? .right : .left)
        } else if newVertical != 0 && newVertical != oldState.vertical {
            send(newVertical > 0 ? .up : .down)
        }

        directionalStates[identifier] = (newHorizontal, newVertical)
    }

    private func send(_ input: ControllerInput) {
        occurrence = ControllerInputOccurrence(input: input)
    }

    private func remove(_ controller: GCController) {
        clearHandlers(controller)
        configuredControllers.removeAll { $0 == controller }
        directionalStates[ObjectIdentifier(controller)] = nil
        updateConnectionState()
    }

    private func updateConnectionState() {
        isControllerConnected = configuredControllers.contains {
            $0.extendedGamepad != nil || $0.microGamepad != nil
        }
    }

    private func clearHandlers(_ controller: GCController) {
        controller.extendedGamepad?.dpad.valueChangedHandler = nil
        controller.extendedGamepad?.leftThumbstick.valueChangedHandler = nil
        controller.extendedGamepad?.buttonA.pressedChangedHandler = nil
        controller.extendedGamepad?.buttonB.pressedChangedHandler = nil
        controller.extendedGamepad?.buttonMenu.pressedChangedHandler = nil
        controller.microGamepad?.dpad.valueChangedHandler = nil
        controller.microGamepad?.buttonA.pressedChangedHandler = nil
        controller.microGamepad?.buttonX.pressedChangedHandler = nil
        controller.microGamepad?.buttonMenu.pressedChangedHandler = nil
    }
}

extension View {
    func controllerFocused(_ isFocused: Bool, cornerRadius: CGFloat = 12) -> some View {
        overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(.tint, lineWidth: 4)
                .shadow(color: .accentColor, radius: 5)
                .opacity(isFocused ? 1 : 0)
        }
        .scaleEffect(isFocused ? 1.04 : 1)
        .animation(.easeOut(duration: 0.12), value: isFocused)
    }

    func controllerScrollable() -> some View {
        modifier(ControllerScrollableModifier())
    }
}

private struct ControllerScrollableModifier: ViewModifier {
    @EnvironmentObject private var controllerInput: ControllerInputMonitor
    @State private var scrollPosition = ScrollPosition(y: 0)
    @State private var contentOffset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .scrollPosition($scrollPosition)
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                geometry.contentOffset.y
            } action: { _, newOffset in
                contentOffset = newOffset
            }
            .onChange(of: controllerInput.occurrence) { _, occurrence in
                guard controllerInput.isControllerConnected,
                      let occurrence,
                      occurrence.input == .up || occurrence.input == .down else { return }

                let distance: CGFloat = occurrence.input == .down ? 220 : -220
                withAnimation(.easeOut(duration: 0.2)) {
                    scrollPosition.scrollTo(y: max(contentOffset + distance, 0))
                }
            }
    }
}
