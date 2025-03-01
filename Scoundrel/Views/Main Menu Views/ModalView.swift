//
//  ModalView.swift
//  Scoundrel
//
//  Created by David Freeman on 2/28/25.
//

import SwiftUI

struct ModalView<Content: View>: View {
    @Binding var isPresented: Bool
    @ViewBuilder var content: Content
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea(.all)
                .foregroundStyle(.ultraThinMaterial)
                .opacity(0.7)
            
            Group {
                Image("paper")
                    .resizable()
                    .cornerRadius(20)
                
                content
            }
            .padding()
            .padding(.top, 40)
            
            VStack {
                HStack {
                    Button(action: { isPresented = false },label: {
                        ZStack {
                            Image("stoneButton")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .shadow(color: .black, radius: 2, x: 0, y: 0)
                            
                            Text("X")
                                .font(.custom("MorrisRoman-Black", size: 30))
                                .foregroundStyle(.white)
                                .shadow(color: .black, radius: 2, x: 0, y: 0)
                        }
                    })
                    .padding(.leading)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    struct ModalView_Preview: View {
        @State var isPresented: Bool = true
        
        var body: some View {
            ModalView(isPresented: $isPresented, content: { Text("Hello, World!") })
        }
    }
    
    return ModalView_Preview()
}
