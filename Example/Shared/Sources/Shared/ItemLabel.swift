// ItemLabel.swift
// PickBetter
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import SwiftUI

public struct ItemLabel: View {
    private let itemId: String

    public init(itemId: String) {
        self.itemId = itemId
    }

    public var body: some View {
        Text("Cell - \(itemId)").font(font)
    }

    private var font: Font {
        #if os(macOS)
            return Font.body
        #else
            return Font.largeTitle
        #endif
    }
}

extension ItemLabel {
    public init<T>(itemId: T) where T: LosslessStringConvertible {
        self.init(itemId: String(itemId))
    }
}
