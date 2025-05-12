//
//  BabyViewModel.swift
//  Hush Alert
//
//  Created by Muhammad Sabihul Hasan on 12/05/25.
//


import Foundation
import Combine

final class BabyViewModel: ObservableObject {
    
    @Published private(set) var baby: Baby?
        
    func addBaby(name: String, date: Date, gender: Gender) {
        baby = Baby(name: name, birthDate: date, gender: gender)
        saveToDisk()
    }
        
    init() { loadFromDisk() }
    
    private let fileName = "baby.json"
    
    private var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory,
                                 in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }
    
    private func loadFromDisk() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        baby = try? JSONDecoder().decode(Baby.self, from: data)
    }
    
    private func saveToDisk() {
        guard let baby else { return }
        if let data = try? JSONEncoder().encode(baby) {
            try? data.write(to: fileURL, options: [.atomicWrite, .completeFileProtection])
        }
    }
    
    func deleteSavedBaby() {
        try? FileManager.default.removeItem(at: fileURL)
        baby = nil
    }
}
