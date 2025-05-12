//
//  PermissionRequestView.swift
//  Hush Alert
//
//  Created by Muhammad Sabihul Hasan on 12/05/25.
//


import SwiftUI

struct PermissionRequestView: View {
    
    @StateObject var viewModel: PermissionViewModel = .init()
    var onDone: () -> Void = {}
        
    var body: some View {
        VStack(spacing: 28) {
            
            Text("Allow us the following permissions")
                .font(.system(size: 34, weight: .bold))
                .multilineTextAlignment(.leading)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Image("baby-sleep")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 200)
                .padding(.vertical, 12)
            
            VStack(spacing: 22) {
                permissionRow(
                    symbol: "mic.fill",
                    label: "Microphone",
                    isGranted: viewModel.micGranted,
                    requestAction: viewModel.requestMicrophone
                )
                .padding(.horizontal, 5)
                
                permissionRow(
                    symbol: "bell.badge.fill",
                    label: "Notifications",
                    isGranted: viewModel.notifGranted,
                    requestAction: viewModel.requestNotifications
                )
                .padding(.horizontal, 5)
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                if viewModel.allGranted {
                    onDone()
                } else {
                    viewModel.requestBoth()
                }
            } label: {
                Label("Allow", systemImage: "checkmark.shield.fill")
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "#91D6EE"))
                    )
                    .foregroundColor(.white)
            }
            .disabled(!viewModel.allGranted)
            .opacity(viewModel.allGranted ? 1 : 0.5)
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .background(Color(hex: "#E8F4F5").ignoresSafeArea())
        .onChange(of: viewModel.allGranted) { _, newValue in
            if newValue { onDone() }
        }
    }
        
    @ViewBuilder
    private func permissionRow(symbol: String,
                               label: String,
                               isGranted: Bool,
                               requestAction: @escaping () -> Void) -> some View {
        HStack {
            Image(systemName: symbol)
                .frame(width: 24)
            Text(label)
                .font(.headline)
            Spacer()
            Toggle("", isOn: Binding(
                get: { isGranted },
                set: { _ in requestAction() }
            ))
            .labelsHidden()
            .disabled(isGranted)
        }
    }
}

#Preview {
    PermissionRequestView()
}
