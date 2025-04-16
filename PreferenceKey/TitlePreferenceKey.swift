//
//  TitlePreferenceKey.swift
//  PreferenceKey
//
//  Created by Eduardo Hoyos on 16/04/25.
//

import SwiftUI

struct TitlePreferenceKey: PreferenceKey {
    static var defaultValue: [String] = []

    static func reduce(value: inout [String], nextValue: () -> [String]) {
        value.append(contentsOf: nextValue())
    }
}
