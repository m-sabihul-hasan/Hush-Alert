//
//  Hush_AlertApp.swift
//  Hush Alert
//
//  Created by Muhammad Sabihul Hasan on 05/05/25.
//


import SwiftUI

@main
struct Hush_AlertApp: App {
    @State private var showLaunchScreen = true

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

















//import SwiftUI
//
//@main
//struct Hush_AlertApp: App {
////    init() { debugResetAppState() }
//    
//    @State private var showLaunchScreen = true
////    @StateObject private var babyVM = BabyViewModel()
////    @StateObject private var permVM = PermissionViewModel()
//
//    var body: some Scene {
//        WindowGroup {
//            if showLaunchScreen {
//                LaunchScreenView()
//                    .onAppear{
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
//                            showLaunchScreen = false
//                        }
//                    }
//            }
//            else {
//                HomeView()
////                Group {
////                    if !permVM.allGranted {
////                        PermissionRequestView() {
////                        }
////                        .environmentObject(permVM)
////                    }
////                    else {
////                        HomeView()
////                            .environmentObject(babyVM)
////                    }
////                }
//            }
//        }
//    }
//}
//
////func debugResetAppState() {
////#if DEBUG
////    // 1. Remove baby.json
////    let fileURL = FileManager.default.urls(for: .documentDirectory,
////                                           in: .userDomainMask)[0]
////        .appendingPathComponent("baby.json")
////    try? FileManager.default.removeItem(at: fileURL)
////    
////    // 2. Clear UserDefaults for this bundle
////    if let bundleID = Bundle.main.bundleIdentifier {
////        UserDefaults.standard.removePersistentDomain(forName: bundleID)
////        UserDefaults.standard.synchronize()
////    }
////    
////    print("🧹 DEBUG RESET: wiped Documents & UserDefaults")
////#endif
////}
