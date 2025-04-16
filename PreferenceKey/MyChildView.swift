//
//  MyChildView.swift
//  PreferenceKey
//
//  Created by Eduardo Hoyos on 16/04/25.
//
import SwiftUI

struct MyChildView: View {
    var body: some View {
        Text("Hello")
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: proxy.size)
                }
            )
    }
}
