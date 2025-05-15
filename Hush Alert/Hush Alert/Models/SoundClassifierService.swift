//
//  SoundClassifierService.swift
//  Hush Alert
//
//  Created by Muhammad Sabihul Hasan on 15/05/25.
//

import Foundation
import CoreML
import SoundAnalysis
import AVFoundation

private let cryModel   = try! BabyCryClassifier1(configuration: .init())

enum SoundClassifierService {

    static func makeLiveAnalyzer()
        -> (start: () -> Void,
            stop : (@escaping ([String: Double]) -> Void) -> Void)
    {
        var engine  : AVAudioEngine?
        var analyzer: SNAudioStreamAnalyzer?
        let collector = MaxAccumulator()

        var started = false
        let tapBus: AVAudioNodeBus = 0

        let start = {
            guard !started else { return }
            started = true
            print("🎙️  LiveAnalyzer START")

            let eng    = AVAudioEngine()
            let input  = eng.inputNode
            let fmt    = input.outputFormat(forBus: tapBus)

            let sa     = SNAudioStreamAnalyzer(format: fmt)
            let req    = try! SNClassifySoundRequest(mlModel: cryModel.model)
            req.windowDuration = CMTime(seconds: 0.25, preferredTimescale: 48_000)
            req.overlapFactor  = 0.25
            try! sa.add(req, withObserver: collector)

            input.installTap(onBus: tapBus,
                             bufferSize: 1_024,
                             format: fmt) { buf, time in
                sa.analyze(buf, atAudioFramePosition: time.sampleTime)
            }
            try? eng.start()

            engine   = eng
            analyzer = sa
        }

        let stop = { (finish: @escaping ([String: Double]) -> Void) in
            guard started else { finish([:]); return }
            started = false
            print("🔚  LiveAnalyzer STOP – completing analysis")

            engine?.inputNode.removeTap(onBus: tapBus)
            engine?.stop()
            analyzer?.completeAnalysis()

            DispatchQueue.global().async {
                let probs = collector.maxProbabilities
                print("📊  LiveAnalyzer DICT size =", probs.count)
                finish(probs)
            }

            engine   = nil
            analyzer = nil
        }

        return (start, stop)
    }
}

private final class MaxAccumulator: NSObject, SNResultsObserving {
    private(set) var maxProbabilities: [String: Double] = [:]

    func request(_ r: SNRequest, didProduce result: SNResult) {
        guard let res = result as? SNClassificationResult else { return }
        for c in res.classifications {
            maxProbabilities[c.identifier] = max(
                maxProbabilities[c.identifier] ?? 0,
                Double(c.confidence)
            )
        }
    }
}

extension Dictionary where Key == String, Value == Double {
    /// Returns a new dict whose values sum to 1.0 (empty dict returns itself).
    func normalised() -> [String: Double] {
        let total = values.reduce(0, +)
        guard total > 0 else { return self }
        return mapValues { $0 / total }
    }
}
