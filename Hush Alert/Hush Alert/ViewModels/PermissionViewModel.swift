//
//  PermissionViewModel.swift
//  Hush Alert
//
//  Created by Muhammad Sabihul Hasan on 12/05/25.
//


import SwiftUI
import AVFAudio          // iOS 17 microphone API
import AVFoundation
import UserNotifications

@MainActor
final class PermissionViewModel: ObservableObject {
    
    // Live permission states
    @Published var micGranted   = false
    @Published var notifGranted = false
    
    /// `true` when *both* permissions are authorised
    var allGranted: Bool { micGranted && notifGranted }
    
    // MARK: – Init
    
    init() {
        refreshStatuses()
    }
    
    // MARK: – Public
    
    /// Ask for microphone access, using the correct API per OS version
    func requestMicrophone() {
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission { [weak self] granted in
                Task { self?.micGranted = granted }
            }
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
                Task { self?.micGranted = granted }
            }
        }
    }
    
    /// Ask for notification permission
    func requestNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                Task { self?.notifGranted = granted }
            }
    }
    
    /// Convenience to request both at once
    func requestBoth() {
        requestMicrophone()
        requestNotifications()
    }
    
    // MARK: – Helpers
    
    /// Refresh stored permission states (run at launch)
    private func refreshStatuses() {
        if #available(iOS 17.0, *) {
            micGranted = AVAudioApplication.shared.recordPermission == .granted
        } else {
            micGranted = AVAudioSession.sharedInstance().recordPermission == .granted
        }
        
        UNUserNotificationCenter.current()
            .getNotificationSettings { [weak self] settings in
                Task { self?.notifGranted = settings.authorizationStatus == .authorized }
            }
    }
}
