//
//  Hush_AlertApp.swift
//  Hush Alert
//
//  Created by Muhammad Sabihul Hasan on 05/05/25.
//


import SwiftUI
import CoreML

@main
struct Hush_AlertApp: App {
    @State private var showLaunchScreen = true
    

    init() {
        DispatchQueue.global(qos: .utility).async {
            let n = 44_100
            if let arr = try? MLMultiArray(shape: [NSNumber(value: n)],
                                           dataType: .float32),
               let model = try? BabyCryClassifier1(configuration: .init()) {
                memset(arr.dataPointer, 0, n * MemoryLayout<Float32>.size)
                _ = try? model.prediction(audioSamples: arr)
                print("🔥 Core-ML weights loaded (only)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if showLaunchScreen {
                LaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            showLaunchScreen = false
                        }
                    }
            } else {
                TabsView()
            }
        }
    }
}

