// CellWrapper.swift
// PickBetter
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import SwiftUI

@MainActor
struct CellWrapper<Content>: View where Content: View {
    let isSelected: Bool
    let content: Content

    init(isSelected: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.isSelected = isSelected
        self.content = content()
    }

    init(isSelected: Bool, content: @autoclosure () -> Content) {
        self.isSelected = isSelected
        self.content = content()
    }

    var body: some View {
        content
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(traitsToAdd())
            .accessibilityRemoveTraits(traitsToRemove())
    }

    private func traitsToAdd() -> AccessibilityTraits {
        if isSelected {
            return [.isSelected, .isButton]
        } else {
            return [.isButton]
        }
    }

    private func traitsToRemove() -> AccessibilityTraits {
        if isSelected {
            return []
        } else {
            return [.isSelected]
        }
    }
}
