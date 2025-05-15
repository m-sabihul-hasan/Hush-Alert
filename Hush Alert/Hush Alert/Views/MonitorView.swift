////
////  MonitorView.swift
////  Hush Alert
////
////  Created by Muhammad Sabihul Hasan on 12/05/25.
////
//
//
//import SwiftUI
//
//struct MonitorView: View {
//    @EnvironmentObject var vm: BabyViewModel
//    
//    @State private var currentGuessIndex = 0
//    
//    var body: some View {
//        VStack(spacing: 16) {
//            Text("HUSH ALERT")
//                .font(.system(size: 48, weight: .heavy, design: .rounded))
//                .foregroundStyle(.blue)
//                .padding(.top, 8)
//            
//            // ——— name + age ———
//            if let baby = vm.baby {
//                Text(baby.name)
//                    .font(.system(size: 34, weight: .bold))
//                Text("\(baby.birthDate.ageInMonths) months")
//                    .font(.system(size: 17))
//            }
//            
//            VStack {
//                Image("baby-single")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 200, height: 200)
//                Image(systemName: "mic.slash.fill")
//                    .resizable()
//                    .frame(width: 70, height: 70)
//                    .opacity(0.85)
//                    .offset(x: -80, y: -50)
//            }
//            .padding(.vertical, 6)
//            
//            // ——— header text ———
//            VStack(spacing: 4) {
//                Text("What happened?")
//                    .font(.title2.weight(.bold))
//                Text("Our best guess: help us confirming it")
//                    .font(.subheadline)
//                    .foregroundStyle(.secondary)
//            }
//            .padding(.top, 4)
//            
//            ZStack {
//                // arrows
//                HStack {
//                    Button { pageBackward() } label: {
//                        Image(systemName: "arrow.left.circle")
//                            .font(.title2)
//                    }
//                    Spacer()
//                    Button { pageForward() } label: {
//                        Image(systemName: "arrow.right.circle")
//                            .font(.title2)
//                    }
//                }
//                .padding(.horizontal, 24)
//                
//                TabView(selection: $currentGuessIndex) {
//                    ForEach(Array(CryCause.allCases.enumerated()), id: \.offset) { idx, cause in
//                        Text(cause.rawValue)
//                            .font(.title2)
//                            .frame(maxWidth: .infinity, maxHeight: 120)
//                            .background(RoundedRectangle(cornerRadius: 18).fill(Color.gray.opacity(0.3 + (idx == currentGuessIndex ? 0 : 0.1))))
//                            .padding(.horizontal, 28)
//                            .tag(idx)
//                    }
//                }
//                .tabViewStyle(.page(indexDisplayMode: .never))
//                .frame(height: 140)
//            }
//            
//            HStack(spacing: 20) {
//                Button {
//                } label: {
//                    Label("False detection", systemImage: "xmark.circle")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue.opacity(0.6)))
//                        .foregroundStyle(.white)
//                }
//                
//                Button {
//                } label: {
//                    Label("Add log", systemImage: "square.and.pencil")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.yellow))
//                        .foregroundStyle(.black)
//                }
//            }
//            .padding(.top, 6)
//            .padding(.horizontal)
//            
//            // ——— page dots ———
//            HStack(spacing: 8) {
//                ForEach(0..<CryCause.allCases.count, id: \.self) { i in
//                    Circle()
//                        .fill(i == currentGuessIndex ? .black : .gray.opacity(0.4))
//                        .frame(width: 8, height: 8)
//                }
//            }
//            .padding(.top, 4)
//            
//            Spacer()
//        }
//        .padding(.bottom, 8)
//        .background(Color(.systemMint).opacity(0.08).ignoresSafeArea())
//    }
//    
//    // MARK: – paging helpers
//    private func pageForward() {
//        withAnimation { currentGuessIndex = (currentGuessIndex + 1) % CryCause.allCases.count }
//    }
//    private func pageBackward() {
//        withAnimation {
//            currentGuessIndex = (currentGuessIndex - 1 + CryCause.allCases.count) % CryCause.allCases.count
//        }
//    }
//}
//
//extension Date {
//    /// Months between this date and today (floor)
//    var ageInMonths: Int {
//        Calendar.current.dateComponents([.month], from: self, to: .now).month ?? 0
//    }
//}
//
//enum CryCause: String, CaseIterable, Identifiable {
//    case tired = "Tired"
//    case discomfort  = "Discomfort"
//    case hungry = "Hungry"
//    case burping = "Burping"
//    case bellyPain = "Belly Pain"
//    
//    var id: Self { self }
//}
//
//#Preview {
//    let vm = BabyViewModel()
//    vm.addBaby(name: "Johnny", date: Calendar.current.date(byAdding: .month, value: -5, to: .now)!, gender: .male)
//    return MonitorView().environmentObject(vm)
//}
