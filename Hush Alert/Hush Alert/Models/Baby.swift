//
//  Gender.swift
//  Hush Alert
//
//  Created by Muhammad Sabihul Hasan on 12/05/25.
//


import Foundation

enum Gender: String, Codable, CaseIterable, Identifiable {
    case male  = "Male"
    case female = "Female"
    
    var id: Self { self }
}

struct Baby: Codable, Identifiable {
    var id: UUID           // now mutable
    var name: String
    var birthDate: Date
    var gender: Gender
    
    // convenience init for new babies
    init(id: UUID = UUID(),
         name: String,
         birthDate: Date,
         gender: Gender) {
        self.id = id
        self.name = name
        self.birthDate = birthDate
        self.gender = gender
    }
}
