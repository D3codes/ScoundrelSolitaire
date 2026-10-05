//
//  ThemeHelper.swift
//  Scoundrel
//
//  Created by David Freeman on 10/5/26.
//

import SwiftUI

class ThemeHelper {
    @AppStorage(UserDefaultsKeys().selectedTheme) private var selectedTheme: Theme = .Original
    private var themePreview: Theme?
    
    init(themePreview: Theme? = nil) {
        self.themePreview = themePreview
    }
    
    enum Theme: String, CaseIterable, Codable {
        case Original
        case Sketch
    }
    
    func getCardBackgroundName() -> String {
        let theme = themePreview ?? selectedTheme
        
        switch theme {
        case .Sketch:
            return SketchTheme().getCardBackgroundName()
        case .Original:
            fallthrough
        default:
            return OriginalTheme().getCardBackgroundName()
        }
    }
    
    func getCardImageName(suit: Card.Suit, strength: Int) -> String {
        let theme = themePreview ?? selectedTheme
        
        switch theme {
        case .Sketch:
            return SketchTheme().getCardImageName(suit: suit, strength: strength)
        case .Original:
            fallthrough
        default:
            return OriginalTheme().getCardImageName(suit: suit, strength: strength)
        }
    }
}
