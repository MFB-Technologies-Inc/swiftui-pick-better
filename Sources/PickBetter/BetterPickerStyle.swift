// BetterPickerStyle.swift
// PickBetter
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import SwiftUI

/// Models the interface a style for `BetterPicker` must conform to
public protocol BetterPickerStyle {
    typealias CellConfiguration = BetterPickerStyleListCellConfiguration
    typealias Configuration = BetterPickerStyleConfiguration

    /// `View` type for the whole picker
    associatedtype ViewOutput: View

    /// `View` type for each cell
    associatedtype ListCellOutput: View

    /// Builds the overall picker view
    /// - Parameters
    ///     - configuration: `BetterPickerStyleConfiguration`
    /// - Returns
    ///     - `ViewOutput`
    @ViewBuilder @MainActor func makeView(_ configuration: Configuration) -> ViewOutput

    /// Builds each cell view
    /// - Parameters
    ///     - configuration: `BetterPickerStyleListCellConfiguration`
    /// - Returns
    ///     - `ListCellOutput`
    @ViewBuilder @MainActor func makeListCell(_ configuration: CellConfiguration) -> ListCellOutput
}
