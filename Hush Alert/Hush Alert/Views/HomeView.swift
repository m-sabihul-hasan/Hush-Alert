//
//  HomeView.swift
//  Hush Alert
//
//  Created by Muhammad Sabihul Hasan on 12/05/25.
//


import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: BabyViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome back!")
                .font(.largeTitle.bold())
            
            if let baby = viewModel.baby {
                Text("👶 \(baby.name)")
                Text("🎂 \(baby.birthDate.formatted(date: .abbreviated, time: .omitted))")
                Text("🚻 \(baby.gender.rawValue)")
            }
        }
    }
}

#Preview {
    let vm = BabyViewModel()
    vm.addBaby(name: "Ava", date: .now, gender: .female)
    return HomeView()
        .environmentObject(vm)
}