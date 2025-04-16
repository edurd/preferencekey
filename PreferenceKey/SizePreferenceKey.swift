//
//  SizePreferenceKey.swift
//  PreferenceKey
//
//  Created by Eduardo Hoyos on 16/04/25.
//
import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
