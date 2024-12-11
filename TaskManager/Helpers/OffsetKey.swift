//
//  OffsetKey.swift
//  TaskManager
//
//  Created by Vladuslav on 16.06.2024.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
