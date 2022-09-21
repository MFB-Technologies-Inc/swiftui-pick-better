// PlainInlineBetterPickerStyle.swift
// PickBetter
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import SwiftUI

/// 'Default' style with an inline list of cells with a trailing checkmark to indicate selection
public struct PlainInlineBetterPickerStyle: BetterPickerStyle {
    public init() {
        // Protocol requires initialized instance but this type has no properties
    }

    public func makeView(_ configuration: Configuration) -> some View {
        List {
            configuration.listOutput
        }
    }

    public func makeListCell(_ configuration: CellConfiguration) -> some View {
        Button(action: { configuration.trigger() }, label: {
            HStack {
                configuration.label()
                Spacer()
                if configuration.isSelected() {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
            }
        })
    }
}

#if DEBUG
    private struct PreviewItem: Identifiable, Sendable {
        let id: String
    }

    @MainActor
    private var items: [PreviewItem] = ["A", "B", "C"].map { PreviewItem(id: $0) }

    private func itemContent(_ item: PreviewItem) -> some View {
        Text(item.id)
    }

    @MainActor
    struct PlainInlineBetterPickerStyle_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                OptionalSelectionPreview()
                SingleSelectionPreview()
                MultiSelectionPreview()
            }
        }
    }

    @MainActor
    private struct OptionalSelectionPreview: View {
        @State private var selection: PreviewItem.ID? = nil

        var body: some View {
            VStack {
                Text("Optional Selection")
                BetterPicker(items, selection: $selection, content: itemContent)
                    .betterPickerStyle(PlainInlineBetterPickerStyle())
            }
        }
    }

    @MainActor
    private struct SingleSelectionPreview: View {
        @State private var selection: PreviewItem.ID = items.first!.id

        var body: some View {
            VStack {
                Text("Single Selection")
                BetterPicker(items, selection: $selection, content: itemContent)
                    .betterPickerStyle(PlainInlineBetterPickerStyle())
            }
        }
    }

    @MainActor
    private struct MultiSelectionPreview: View {
        @State private var selection: Set<PreviewItem.ID> = []

        var body: some View {
            VStack {
                Text("Multiple Selection")
                BetterPicker(items, selection: $selection, content: itemContent)
                    .betterPickerStyle(PlainInlineBetterPickerStyle())
            }
        }
    }

#endif
