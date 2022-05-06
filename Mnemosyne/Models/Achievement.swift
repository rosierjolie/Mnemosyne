//
//  Achievement.swift
//  Mnemosyne
//
//  Created by Jerry Turcios on 10/17/20.
//

import Foundation

struct Achievement: Codable, Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var imageString: String
    var completed: Bool
}
