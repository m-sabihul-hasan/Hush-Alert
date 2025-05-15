//
//  AudioMonitor.swift
//  Hush Alert
//
//  Created by Muhammad Sabihul Hasan on 15/05/25.
//

import SwiftUI
import AVFoundation
import Accelerate         // RMS helper

final class AudioMonitor: ObservableObject {

    @Published var amplitude: CGFloat = 0
    private let audioEngine = AVAudioEngine()

    func start(duration: TimeInterval = 10,
               completion: @escaping () -> Void = {}) {

        // ✅  type-method call
        AVAudioApplication.requestRecordPermission { [weak self] granted in
            guard granted, let self else { return }

            DispatchQueue.main.async {
                self.configureAndStartEngine(duration: duration,
                                             completion: completion)
            }
        }
    }
    
    func stop() {
        guard audioEngine.isRunning else { return }
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    

    // MARK: – Engine setup
    private func configureAndStartEngine(duration: TimeInterval,
                                         completion: @escaping () -> Void) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord,
                                                            options: [.defaultToSpeaker,
                                                                      .mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)

            let input  = audioEngine.inputNode
            let format = input.outputFormat(forBus: 0)

            input.installTap(onBus: 0,
                             bufferSize: 1_024,
                             format: format) { [weak self] buffer, _ in
                guard let self else { return }

                let scaled = min(max(CGFloat(buffer.rmsValue()) * 20, 0), 1)

                DispatchQueue.main.async {
                    withAnimation(.easeOut(duration: 0.08)) {
                        self.amplitude = scaled
                    }
                }
            }

            try audioEngine.start()

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                guard let self else { return }
                self.audioEngine.stop()
                self.audioEngine.inputNode.removeTap(onBus: 0)
                completion()
            }

        } catch {
            print("Audio engine error:", error)
        }
    }
}

// MARK: – RMS helper
private extension AVAudioPCMBuffer {
    func rmsValue() -> Float {
        guard let ch = floatChannelData else { return 0 }
        var meanSq: Float = 0
        vDSP_measqv(ch[0], 1, &meanSq, vDSP_Length(frameLength))
        return sqrtf(meanSq)
    }
}
