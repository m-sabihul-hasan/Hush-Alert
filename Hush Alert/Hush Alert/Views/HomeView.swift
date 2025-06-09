//
//  HomeView.swift
//  Hush Alert
//
//  Created by Muhammad Sabihul Hasan on 12/05/25.
//
//

import SwiftUI

struct HomeView: View {

    var body: some View {
        NavigationStack {
            ZStack {
                // sky-blue → white gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#8dd5ed"), .white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack {
                    Text("HUSH ALERT")
                        .font(.system(size: 37, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.top, 40)

                    ZStack {
                        Circle()
                            .fill(Color(hex: "#FEF9CF"))
                            .frame(width: 350, height: 350)
                        Image("baby-single")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                    }
                    .padding(.vertical, 30)

//                    Spacer(minLength: 0)

                    VStack(spacing: 16) {
                        
                        NavigationLink {
                            ListeningView()
                        } label: {
                            Text("Classification")
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        
//                        Button {
//                            // TODO
//                        } label: {
//                            Label("Apple Watch", systemImage: "apple.logo")
//
//                        }
//                        .buttonStyle(PrimaryButtonStyle())
                    }
                    .padding(.bottom, 70)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

private struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20, weight: .bold))
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(Color(hex: "#FEE563").opacity(configuration.isPressed ? 0.5 : 1))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.horizontal, 50)
    }
}

#Preview {
    HomeView()
}
