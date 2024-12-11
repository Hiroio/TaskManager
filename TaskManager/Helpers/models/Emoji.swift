//
//  Emoji.swift
//  TaskManager
//
//  Created by Vladuslav on 15.09.2024.
//

import Foundation

struct Emoji: Identifiable, Equatable {
    let value: Int
    var emojiString: String {
        guard let scalar = UnicodeScalar(value) else {return "?"}
        return String(Character(scalar))
    }
    var valueString: String {
        String(format: "%x", value)
    }
    var id: Int{
        return value
    }
    static func examples() -> [Emoji] {
        let values = 0x1f600...0x1f64f
        return values.map { Emoji(value: $0)}
    }
}
