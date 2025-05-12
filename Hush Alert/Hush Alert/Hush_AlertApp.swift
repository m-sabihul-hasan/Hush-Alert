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
    @StateObject private var babyVM = BabyViewModel()
    @State private var permissionsDone = false

    var body: some Scene {
        WindowGroup {
            if showLaunchScreen {
                LaunchScreenView()
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            showLaunchScreen = false
                        }
                    }
            }
            else {
                Group {
                    if babyVM.baby == nil {
                        BabyRegistrationView(viewModel: babyVM)
                    } else if !permissionsDone {
                        PermissionRequestView {
                            permissionsDone = true     // jump to home when finished
                        }
                    } else {
                        HomeView()
                            .environmentObject(babyVM)
                    }
                }
            }
        }
    }
}
