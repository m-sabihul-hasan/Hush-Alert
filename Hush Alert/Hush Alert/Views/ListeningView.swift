//
//  ListeningView.swift
//  Hush Alert
//
//  Created by Muhammad Sabihul Hasan on 15/05/25.
//


import SwiftUI

struct ListeningView: View {

    var recordingDuration: TimeInterval = 6

    @StateObject private var monitor = AudioMonitor()

    // live analyzer pair is recreated every appearance
    @State private var liveStart: (() -> Void)?
    @State private var liveStop : ((@escaping ([String: Double]) -> Void) -> Void)?

    @State private var predictions: [String: Double] = [:]
    @State private var showResults = false

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
        .onAppear { startCapture() }
        .onDisappear { fullStop() }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    fullStop()
                    dismiss()
                } label: {
                    Label("Back", systemImage: "chevron.backward")
                }
            }
        }
        .navigationDestination(isPresented: $showResults) {
            ResultsView(probabilities: predictions) { dismiss() }
                .toolbar(.hidden, for: .tabBar)
        }
    }

    // MARK: – capture / classify
    private func startCapture() {
        // new analyzer each time
        let pair = SoundClassifierService.makeLiveAnalyzer()
        liveStart = pair.start
        liveStop  = pair.stop

        liveStart?()
        monitor.start(duration: recordingDuration) {
            monitor.stop()
            liveStop? { raw in
                let probs = raw.normalised()   // 🔹 ensure they sum to 1.0
                print("✅ ListeningView dict size =", probs.count)
                if !probs.isEmpty {
                    predictions = probs
                    showResults = true
                }
            }
            liveStart = nil
            liveStop  = nil
        }
    }

    private func fullStop() {
        monitor.stop()
        liveStop? { _ in }
        liveStart = nil
        liveStop  = nil
    }
}

// Ripple identical to previous
private struct Ripple: View {
    var amplitude: CGFloat
    @State private var animate = false
    var body: some View {
        ZStack {
            ForEach(0..<3) { i in
                Circle()
                    .stroke(Color(hex: "#A5DEFE").opacity(0.7), lineWidth: 32)
                    .scaleEffect(animate ? 0.7 + amplitude * 0.3 : 0.7)
                    .opacity(animate ? 0 : 1)
                    .animation(.easeOut(duration: 1.3)
                               .repeatForever()
                               .delay(Double(i) * 0.3),
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



//#Preview { NavigationStack { ListeningView() } }
