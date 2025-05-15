//
//  ListeningView.swift
//  Hush Alert
//
//  Created by Muhammad Sabihul Hasan on 15/05/25.
//


import SwiftUI

struct ListeningView: View {

    var recordingDuration: TimeInterval = 10

    @StateObject private var monitor = AudioMonitor()
    @State private var showBlank = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(hex: "#FEF9CF").ignoresSafeArea()

            VStack {
                Spacer()

                Ripple(amplitude: monitor.amplitude)
                    .frame(width: 280, height: 280)

                Spacer()

                Image(systemName: "mic.fill")
                    .font(.system(size: 42))
                    .foregroundStyle(Color(hex: "#A5DEFE"))

                Spacer(minLength: 48)
            }
        }
        .onAppear {
            monitor.start(duration: recordingDuration) {
                showBlank = true
            }
        }
        .navigationDestination(isPresented: $showBlank) {
            SettingsView()
                .toolbar(.hidden, for: .tabBar)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    monitor.stop()
                    dismiss()
                } label: {
                    Label("Back", systemImage: "chevron.backward")
                }
            }
        }
    }
}

private struct Ripple: View {
    var amplitude: CGFloat
    @State private var animate = false

    var body: some View {
        ZStack {
            ForEach(0..<3) { idx in
                Circle()
                    .stroke(Color(hex: "#A5DEFE").opacity(0.7), lineWidth: 32)
                    .scaleEffect(animate ? 0.7 + amplitude * 0.3 : 0.7)
                    .opacity(animate ? 0 : 1)
                    .animation(.easeOut(duration: 1.3)
                               .repeatForever()
                               .delay(Double(idx) * 0.3),
                               value: animate)
            }

            Circle()
                .fill(Color(hex: "#FFEB9B"))
                .frame(width: 120 + amplitude * 30,
                       height: 120 + amplitude * 30)
                .animation(.easeOut(duration: 0.08), value: amplitude)

            Circle()
                .fill(Color(hex: "#FED63F"))
                .frame(width: 60 + amplitude * 40,
                       height: 60 + amplitude * 40)
                .animation(.easeOut(duration: 0.08), value: amplitude)
        }
        .onAppear { animate = true }
    }
}

#Preview {
    NavigationStack { ListeningView() }
}


