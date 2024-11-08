// BetterPickerStyleCellConfiguration.swift
// PickBetter
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import SwiftUI

/// Configuration payload passed to `BetterPickerStyle.makeListCell(_:)`
public struct BetterPickerStyleListCellConfiguration {
    /// Callback for when the cell is selected
    public let select: () -> Void

    /// Callback for when the cell is deselected
    public let deselect: () -> Void

    /// Label for the cell
    public let label: () -> AnyView

    /// Is this cell selected?
    public let isSelected: () -> Bool

    /// Either selects or deselects the cell when interacted with by the user
    public func trigger() {
        if isSelected() {
            deselect()
        } else {
            select()
        }
    }

    init<RowLabel: View>(
        select: @escaping () -> Void,
        deselect: @escaping () -> Void,
        label: @escaping () -> RowLabel,
        isSelected: @escaping () -> Bool
    ) {
        self.select = select
        self.deselect = deselect
        self.label = { AnyView(label()) }
        self.isSelected = isSelected
    }
}
