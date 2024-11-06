// LazyView.swift
// PickBetter
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import SwiftUI

public struct LazyView<Content>: View where Content: View {
    private let content: () -> Content

    public init(_ content: @autoclosure @escaping () -> Content) {
        self.content = content
    }

    public init(_ content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        content()
    }
}
