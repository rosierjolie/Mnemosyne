//
//  Job.swift
//  Mnemosyne
//
//  Created by Jerry Turcios on 9/7/20.
//

import Foundation

enum Status: String, CaseIterable, Codable {
    case applied = "Applied"
    case phoneScreen = "Phone Screen"
    case onSite = "On Site"
    case offer = "Offer"
    case rejected = "Rejected"
}

struct Job: Codable, Identifiable {
    var id = UUID()
    var title: String
    var company: String
    var dateApplied: Date
    var notes: String?
    var contact: String?
    var favorite: Bool
    var status: Status
}
