//
//  BabyRegistrationView.swift
//  Hush Alert
//
//  Created by Muhammad Sabihul Hasan on 12/05/25.
//


import SwiftUI

struct BabyRegistrationView: View {
    @ObservedObject var viewModel: BabyViewModel
    @State private var name = ""
    @State private var birthDate = Date()
    @State private var gender: Gender = .male
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 10)
            HStack{
                Text("Who’s your baby?")
                    .font(.system(size: 32, weight: .bold))
                    .padding()
                
                Spacer()
            }
            Spacer()
            
            Image("baby-single")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
            
            Spacer()
            
            HStack {
                TextField("Baby’s name", text: $name)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 12)
                if !name.isEmpty {
                    Button {
                        name = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.vertical, 12)
            .background(RoundedRectangle(cornerRadius: 6)
                            .fill(Color.white))
            .overlay(RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.secondary.opacity(0.3)))
            .padding(.horizontal)
            
            Spacer()
            
            DatePicker("Birth date",
                       selection: $birthDate,
                       displayedComponents: [.date])
            .datePickerStyle(.wheel)
            .labelsHidden()
            .frame(maxHeight: 150)
            
            Spacer()
            
            Picker("Gender", selection: $gender) {
                ForEach(Gender.allCases) { g in
                    Text(g.rawValue).tag(g)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            Button {
                withAnimation {
                    viewModel.addBaby(name: name.trimmingCharacters(in: .whitespaces),
                                      date: birthDate,
                                      gender: gender)
                }
            } label: {
                Label("Add Baby", systemImage: "person.fill.badge.plus")
//                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#91D6EE")))
                    .foregroundColor(.white)
            }
            .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color(hex: "#E8F4F5").ignoresSafeArea())
    }
}


#Preview {
    BabyRegistrationView(viewModel: BabyViewModel())
}
