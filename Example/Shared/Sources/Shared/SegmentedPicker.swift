// SegmentedPicker.swift
// PickBetter
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import PickBetter
import SwiftUI

public struct SegmentedPickerView: View {
    private let items: [Item]
    @State private var selection: Item.ID = 0

    public init(items: [Item]) {
        self.items = items
    }

    // MARK: Accessibility Ids

    private var segmentedPickerString: String { "segmentedPicker" }

    public struct SegmentedItemLabel: View {
        private let itemId: Int

        public init(itemId: Int) {
            self.itemId = itemId
        }

        public var body: some View {
            Text("Segmented \(itemId)")
        }
    }

    public var body: some View {
        LazyView(
            BetterPicker(items, selection: $selection, content: { SegmentedItemLabel(itemId: $0.id) })
                .betterPickerStyle(SegmentedBetterPickerStyle(frameWidth: 500.0))
                .accessibilityIdentifier(segmentedPickerString)
        )
    }
}
