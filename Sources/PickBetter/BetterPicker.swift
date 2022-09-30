// BetterPicker.swift
// PickBetter
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import SwiftUI

/// A custom implementation of a 'Picker' UI element with less magic than SwiftUI's provided `Picker`
@MainActor
public struct BetterPicker<SelectionBox, ItemContent>: View where SelectionBox: BetterPickerSelection,
    ItemContent: View
{
    /// The type used for tracking selection
    public typealias SelectionValue = SelectionBox.SelectionValue

    /// Container for a given selection value and associated cell view
    typealias ItemTuple = (SelectionValue, () -> ItemContent)

    private let items: [ItemTuple]
    @Binding private var selection: SelectionBox

    public var body: some View {
        self.betterPickerStyle(PlainInlineBetterPickerStyle())
    }

    /// Accessor function used by styles to build the view
    /// - Parameters
    ///     - style: `Style` (BetterPickerStyle)
    /// - Returns
    ///     - `some View`
    public func betterPickerStyle<Style: BetterPickerStyle>(_ style: Style) -> some View {
        let styledItems: [(SelectionValue, () -> CellWrapper<Style.ListCellOutput>)] = items
            .map { item in
                let configuration = Style.CellConfiguration(
                    select: { selection.didSelect(item.0) },
                    deselect: { selection.didDeselect(item.0) },
                    label: item.1,
                    isSelected: { selection.contains(item.0) }
                )
                return (
                    item.0,
                    { CellWrapper(isSelected: configuration.isSelected(), content: style.makeListCell(configuration)) }
                )
            }
        let forEachStyledItems = ForEach(styledItems, id: \.0) { styledItem in
            styledItem.1()
        }
        let configuration = Style.Configuration(
            listOutput: AnyView(forEachStyledItems),
            cellCount: items.count,
            selectionCount: selection.count,
            selectionLabels: items.filter { selection.contains($0.0) }.map { AnyView($0.1()) }
        )
        let styledBody = style.makeView(configuration)
        return styledBody
    }

    fileprivate init(items: [ItemTuple], selection: Binding<SelectionBox>) {
        self.items = items
        _selection = selection
    }

    fileprivate static func itemsFromData<Data>(
        _ data: Data,
        selectionValue: @escaping (Data.Element) -> SelectionValue,
        content: @MainActor @escaping (Data.Element) -> ItemContent
    ) -> [ItemTuple] where Data: Sequence {
        data.map { item in (selectionValue(item), { content(item) }) }
    }

    // MARK: Init with closure to map from Option to Selection

    /// Initializer for an array of identifiable elements where there is always one selection (never nil)
    /// - Parameters
    ///     - data: Data -- `Sequence`
    ///     - selectionValue: `@escaping (Data.Element) -> SelectionValue`
    ///     - selection: `Binding<SelectionValue>`
    ///     - content: `(Data.Element) -> ItemContent` -- View builder for a cell
    public init<Data, UnwrappedSelection>(
        _ data: Data,
        selectionValue: @escaping (Data.Element) -> SelectionValue,
        selection: Binding<SelectionValue>,
        @ViewBuilder content: @MainActor @escaping (Data.Element) -> ItemContent
    ) where Data: Sequence, SelectionBox == SingleSelectionWrapper<UnwrappedSelection> {
        let selectionBinding: Binding<SingleSelectionWrapper<SelectionValue>> = Binding(
            get: { SingleSelectionWrapper(value: selection.wrappedValue) },
            set: { selection.wrappedValue = $0.value }
        )
        self.init(
            items: Self.itemsFromData(data, selectionValue: selectionValue, content: content),
            selection: selectionBinding
        )
    }

    /// Initializer for an array of identifiable elements where the selection is a single optional value
    /// - Parameters
    ///     - data: Data -- `Sequence`
    ///     - selectionValue: `@escaping (Data.Element) -> SelectionValue`
    ///     - selection: `Binding<SelectionValue?>`
    ///     - content: `(Data.Element) -> ItemContent` -- View builder for a cell
    public init<Data, WrappedSelectionValue>(
        _ data: Data,
        selectionValue: @escaping (Data.Element) -> SelectionValue,
        selection: Binding<WrappedSelectionValue?>,
        @ViewBuilder content: @MainActor @escaping (Data.Element) -> ItemContent
    ) where Data: Sequence, SelectionBox == WrappedSelectionValue? {
        self.init(
            items: Self.itemsFromData(data, selectionValue: selectionValue, content: content),
            selection: selection
        )
    }
}

extension BetterPicker where SelectionBox: Sequence {
    /// Initializer for an array of identifiable elements where multiple selections can be made
    /// - Parameters
    ///     - data: Data -- `Sequence`
    ///     - selectionValue: `@escaping (Data.Element) -> SelectionValue`
    ///     - selection: `Binding<SelectionBox>`
    ///     - content: `(Data.Element) -> ItemContent` -- View builder for a cell
    public init<Data>(
        _ data: Data,
        selectionValue: @escaping (Data.Element) -> SelectionValue,
        selection: Binding<SelectionBox>,
        @ViewBuilder content: @MainActor @escaping (Data.Element) -> ItemContent
    ) where Data: Sequence, Data.Element == SelectionBox.SelectionValue {
        self.init(
            items: Self.itemsFromData(data, selectionValue: selectionValue, content: content),
            selection: selection
        )
    }
}

// MARK: Init where Selection == Option

extension BetterPicker {
    /// Initializer for an array of identifiable elements where there is always one selection (never nil)
    /// - Parameters
    ///     - data: Data -- `Sequence` where  `Data.Element == SelectionValue`
    ///     - selection: `Binding<SelectionValue>`
    ///     - content: `(Data.Element) -> ItemContent` -- View builder for a cell
    public init<Data, UnwrappedSelection>(
        _ data: Data,
        selection: Binding<SelectionValue>,
        @ViewBuilder content: @MainActor @escaping (Data.Element) -> ItemContent
    ) where Data: Sequence, Data.Element == SelectionValue,
        SelectionBox == SingleSelectionWrapper<UnwrappedSelection>
    {
        let selectionBinding: Binding<SingleSelectionWrapper<SelectionValue>> = Binding(
            get: { SingleSelectionWrapper(value: selection.wrappedValue) },
            set: { selection.wrappedValue = $0.value }
        )
        self.init(
            items: Self.itemsFromData(data, selectionValue: { $0 }, content: content),
            selection: selectionBinding
        )
    }

    /// Initializer for an array of identifiable elements where the selection is a single optional value
    /// - Parameters
    ///     - data: Data -- `Sequence` where  `Data.Element == SelectionValue`
    ///     - selection: `Binding<SelectionValue?>`
    ///     - content: `(Data.Element) -> ItemContent` -- View builder for a cell
    public init<Data, WrappedSelectionValue>(
        _ data: Data,
        selection: Binding<WrappedSelectionValue?>,
        @ViewBuilder content: @MainActor @escaping (Data.Element) -> ItemContent
    ) where Data: Sequence, Data.Element == WrappedSelectionValue,
        SelectionBox == WrappedSelectionValue?
    {
        self.init(
            items: Self.itemsFromData(data, selectionValue: { $0 }, content: content),
            selection: selection
        )
    }
}

extension BetterPicker where SelectionBox: Sequence {
    /// Initializer for an array of identifiable elements where multiple selections can be made
    /// - Parameters
    ///     - data: Data -- `Sequence` where  `Data.Element == SelectionValue`
    ///     - selection: `Binding<SelectionBox>`
    ///     - content: `(Data.Element) -> ItemContent` -- View builder for a cell
    public init<Data>(
        _ data: Data,
        selection: Binding<SelectionBox>,
        @ViewBuilder content: @MainActor @escaping (Data.Element) -> ItemContent
    ) where Data: Sequence, Data.Element == SelectionBox.SelectionValue {
        self.init(
            items: Self.itemsFromData(data, selectionValue: { $0 }, content: content),
            selection: selection
        )
    }
}

// MARK: Init where Option: Identifiable and Selection == Option.ID

extension BetterPicker {
    /// Initializer for an array of identifiable elements where there is always one selection (never nil)
    /// - Parameters
    ///     - data: Data -- `Sequence` where  `Data.Element: Identifiable`, `Data.Element.ID == SelectionValue`
    ///     - selection: `Binding<SelectionValue>`
    ///     - content: `(Data.Element) -> ItemContent` -- View builder for a cell
    public init<Data, UnwrappedSelection>(
        _ data: Data,
        selection: Binding<SelectionValue>,
        @ViewBuilder content: @MainActor @escaping (Data.Element) -> ItemContent
    ) where Data: Sequence, Data.Element: Identifiable, Data.Element.ID == SelectionValue,
        SelectionBox == SingleSelectionWrapper<UnwrappedSelection>
    {
        let selectionBinding: Binding<SingleSelectionWrapper<SelectionValue>> = Binding(
            get: { SingleSelectionWrapper(value: selection.wrappedValue) },
            set: { selection.wrappedValue = $0.value }
        )
        self.init(items: Self.itemsFromData(data, selectionValue: \.id, content: content), selection: selectionBinding)
    }

    /// Initializer for an array of identifiable elements where the selection is a single optional value
    /// - Parameters
    ///     - data: Data -- `Sequence` where  `Data.Element: Identifiable`, `Data.Element.ID == SelectionValue`
    ///     - selection: `Binding<SelectionValue?>`
    ///     - content: `(Data.Element) -> ItemContent` -- View builder for a cell
    public init<Data, WrappedSelectionValue>(
        _ data: Data,
        selection: Binding<WrappedSelectionValue?>,
        @ViewBuilder content: @MainActor @escaping (Data.Element) -> ItemContent
    ) where Data: Sequence, Data.Element: Identifiable, Data.Element.ID == WrappedSelectionValue,
        SelectionBox == WrappedSelectionValue?
    {
        self.init(
            items: Self.itemsFromData(data, selectionValue: \.id, content: content),
            selection: selection
        )
    }
}

extension BetterPicker where SelectionBox: Sequence {
    /// Initializer for an array of identifiable elements where multiple selections can be made
    /// - Parameters
    ///     - data: Data -- `Sequence` where  `Data.Element: Identifiable`, `Data.Element.ID == SelectionValue`
    ///     - selection: `Binding<SelectionBox>`
    ///     - content: `(Data.Element) -> ItemContent` -- View builder for a cell
    public init<Data>(
        _ data: Data,
        selection: Binding<SelectionBox>,
        @ViewBuilder content: @MainActor @escaping (Data.Element) -> ItemContent
    ) where Data: Sequence, Data.Element: Identifiable, SelectionBox.Element == Data.Element.ID,
        SelectionBox.Element == SelectionBox.SelectionValue
    {
        self.init(
            items: Self.itemsFromData(data, selectionValue: \.id, content: content),
            selection: selection
        )
    }
}
