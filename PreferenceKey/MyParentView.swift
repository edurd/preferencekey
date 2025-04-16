//
//  ContentView.swift
//  PreferenceKey
//
//  Created by Eduardo Hoyos on 16/04/25.
//

import SwiftUI

struct MyParentView: View {
    @State private var size: CGSize = .zero

    var body: some View {
        VStack {
            MyChildView()
                .onPreferenceChange(SizePreferenceKey.self) { newSize in
                    size = newSize
                }

            Text("Child size: \(Int(size.width)) x \(Int(size.height))")
        }
    }
}
