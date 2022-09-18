// BetterPickerStyleConfiguration.swift
// PickBetter
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import SwiftUI

/// Configuration payload passed to `BetterPickerStyle.makeView(_:)`
@MainActor
public struct BetterPickerStyleConfiguration {
    /// The view output of all the cells combined
    public let listOutput: AnyView

    /// The number of cells
    public let cellCount: Int

    /// The number of selections
    public let selectionCount: Int

    /// The label views for the selected cells
    public let selectionLabels: [AnyView]
}
