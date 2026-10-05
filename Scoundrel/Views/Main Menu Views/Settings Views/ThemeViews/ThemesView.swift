//
//  ThemesView.swift
//  Scoundrel
//
//  Created by David Freeman on 10/5/26.
//

import SwiftUI

struct ThemesView: View {
    @AppStorage(UserDefaultsKeys().selectedTheme) private var storedTheme: ThemeHelper.Theme = ThemeHelper.Theme.Original
    
    @State private var selectedTheme: ThemeHelper.Theme?

    private var currentTheme: ThemeHelper.Theme {
        selectedTheme ?? storedTheme
    }
    
    var body: some View {
        ZStack {
            Image("paper")
                .resizable()
                .ignoresSafeArea(edges: .all)
            
            VStack {
                Text("Themes")
                    .font(.custom("ModernAntiqua-Regular", size: 40))
                    .foregroundStyle(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .ignoresSafeArea()
            .zIndex(10)
            
            List {
                Rectangle()
                    .frame(height: 1)
                    .opacity(0)
                    .listRowBackground(Rectangle().opacity(0))
                
                Section {
                    ForEach(ThemeHelper.Theme.allCases, id: \.rawValue) { theme in
                        Button {
                            selectedTheme = theme
                            storedTheme = theme
                        } label: {
                            ThemePreviewView(
                                theme: theme,
                                isSelected: currentTheme == theme
                            )
                        }
                        .listRowBackground(Rectangle().fill(.thinMaterial))
                        .foregroundStyle(.foreground)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .ignoresSafeArea(edges: .top)
        }
    }
}

#Preview {
    Text("HI")
        .sheet(isPresented: .constant(true)) {
            ThemesView()
        }
}
