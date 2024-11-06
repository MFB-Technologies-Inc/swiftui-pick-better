// BetterPickerSelection.swift
// PickBetter
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import SwiftUI

/// Models the interactions neccessary for a given concrete type to act as `BetterPicker.SelectionBox`
public protocol BetterPickerSelection {
    /// The underlying type that models `BetterPicker.SelectionValue`
    associatedtype SelectionValue: Hashable

    /// Test if a given value is selected
    /// - Parameters
    ///     - item: SelectionValue
    /// - Returns
    ///     - Bool
    func contains(_ item: SelectionValue) -> Bool

    /// The number of values that are selected
    var count: Int { get }

    /// Sets a given value as selected
    ///     - item: SelectionValue
    mutating func didSelect(_ item: SelectionValue)

    /// Sets a given value as not selected
    ///  - Parameters
    ///     - item: SelectionValue
    mutating func didDeselect(_ item: SelectionValue)
}

// MARK: `Set` Implementation

extension Set: BetterPickerSelection {
    public mutating func didSelect(_ item: Element) {
        insert(item)
    }

    public mutating func didDeselect(_ item: Element) {
        remove(item)
    }
}

// MARK: `Array` Implementation

extension Array: BetterPickerSelection where Element: Hashable {
    public mutating func didSelect(_ item: Element) {
        if !contains(item) {
            append(item)
        }
    }

    public mutating func didDeselect(_ item: Element) {
        removeAll(where: { $0 == item })
    }
}

// MARK: `Optional` Implementation

extension Optional: BetterPickerSelection where Wrapped: Hashable {
    public func contains(_ item: Wrapped) -> Bool {
        self == item
    }

    public var count: Int {
        if case .none = self {
            return 0
        } else {
            return 1
        }
    }

    public mutating func didSelect(_ item: Wrapped) {
        self = item
    }

    public mutating func didDeselect(_: Wrapped) {
        self = nil
    }
}

// MARK: `SingleSelectionWrapper` Implementation

/// Concrete implementation of `BetterPickerSelection` for non-optional, single value selection
public struct SingleSelectionWrapper<SelectionValue: Hashable>: BetterPickerSelection {
    var value: SelectionValue

    public func contains(_ item: SelectionValue) -> Bool {
        value == item
    }

    public var count: Int { 1 }

    public mutating func didSelect(_ item: SelectionValue) {
        value = item
    }

    public mutating func didDeselect(_: SelectionValue) {
        // Required by protocol conformance
    }
}

extension SingleSelectionWrapper: Sendable where SelectionValue: Sendable {}
