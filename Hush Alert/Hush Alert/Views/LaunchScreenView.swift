//
//  LaunchScreenView.swift
//  Hush Alert
//
//  Created by Muhammad Sabihul Hasan on 11/05/25.
//

import SwiftUI

struct LaunchScreenView: View {
    
    @State private var floating = false
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#8dd5ed"), .white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                Text("Because Love Doesn’t\nNeed Sound")
                    .font(.system(size: 35, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                Text("Feel the cry . Answer with love .")
                    .font(.system(size: 23))
                    .foregroundColor(.white)
                    .padding(.bottom, 50)
                
                Image("baby-sleep")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    // Move 20 pt up or down
                    .offset(y: floating ? -20 : 20)
                    .onAppear {
                        // Start an endless, autoreversing animation
                        withAnimation(
                            .easeInOut(duration: 0.6)
                                .repeatForever(autoreverses: true)
                        ) {
                            floating.toggle()
                        }
                    }
                
                Spacer()
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    LaunchScreenView()
}
