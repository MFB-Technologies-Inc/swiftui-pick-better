// SegmentedBetterPickerStyle.swift
// PickBetter
//
// Copyright © 2026 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import SwiftUI

/// 'Segmented' style that mimics Apple's PickerStyle.segmented
public struct SegmentedBetterPickerStyle: BetterPickerStyle {
    /// Width of the entire Picker. Required property in order to calculate cell size correctly.
    private let frameWidth: CGFloat
    /// Height of the entire Picker. Defaults to '32', the same height used in Apple's segmented Picker.
    private let frameHeight: CGFloat
    /// Horizontal alignment for the inner ``View`` of the cells. Defaults to ``.center`` alignment.
    private let horizontalCellAlignment: HorizontalAlignment

    /// Static value for the amount of padding between cell selection frame and parent frame
    private let cellSelectionPadding: CGFloat = 2.0

    /// Memberwise initializer
    public init(
        frameWidth: CGFloat,
        frameHeight: CGFloat = 32,
        horizontalCellAlignment: HorizontalAlignment = .center
    ) {
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        self.horizontalCellAlignment = horizontalCellAlignment
    }

    /// Builds the overall picker ``View``.
    public func makeView(_ configuration: Configuration) -> some View {
        // Full width of the `View` for a cell.
        let cellWidth = (frameWidth / CGFloat(configuration.cellCount)) - 1.5
        // Index of the selected cell.
        let selectCellIndex = configuration.selectionIndexSet.first

        ZStack(alignment: .leading) {
            if let selectCellIndex = selectCellIndex {
                // Rounded background to display selected item
                RoundedRectangle(cornerRadius: 6)
                    .fill(.white)
                    .frame(width: cellWidth, height: frameHeight - (cellSelectionPadding * 2))
                    .offset(x: CGFloat(selectCellIndex) * cellWidth)
                    .animation(.easeInOut(duration: 0.25), value: selectCellIndex)
                    .padding(cellSelectionPadding)
                    .shadow(color: .secondary.opacity(0.3), radius: 2, y: 1)
            }

            addCellDividers(
                cellCount: configuration.cellCount,
                cellWidth: cellWidth,
                selectCellIndex: selectCellIndex
            )

            HStack {
                configuration.listOutput
            }
            .foregroundStyle(.black)
            .frame(width: frameWidth, height: frameHeight)
        }
        .background(Color(red: 0.92, green: 0.92, blue: 0.92))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    /// Builds each individual cell ``View``.
    public func makeListCell(_ configuration: CellConfiguration) -> some View {
        Button(action: {
            configuration.select()
        }) {
            HStack {
                if [.center, .trailing].contains(horizontalCellAlignment) {
                    Spacer()
                }

                configuration.label()
                    .padding(.horizontal, 6)

                if [.center, .leading].contains(horizontalCellAlignment) {
                    Spacer()
                }
            }
        }
        .contentShape(Rectangle()) // Used to make the entire HStack tappable
    }

    /// Adds dividers between cells
    public func addCellDividers(
        cellCount: Int,
        cellWidth: CGFloat,
        selectCellIndex: IndexSet.Element?
    ) -> some View {
        ForEach(1 ..< cellCount, id: \.self) { index in
            // Ignore cells that are touching the selectedCell
            if let selectCellIndex = selectCellIndex {
                if index != selectCellIndex + 1, index != selectCellIndex {
                    cellDivider(index: index, cellWidth: cellWidth)
                }
            } else {
                cellDivider(index: index, cellWidth: cellWidth)
            }
        }
    }

    /// Draw divider between cells
    private func cellDivider(
        index: IndexSet.Element,
        cellWidth: CGFloat
    ) -> some View {
        Rectangle()
            .frame(width: 1, height: frameHeight - 16)
            .offset(x: CGFloat(index) * cellWidth)
            .foregroundColor(.gray.opacity(0.4))
    }
}

#if DEBUG
    private struct PreviewItem: Identifiable, Sendable {
        let id: String
        let imageString: String
    }

    private let items: [PreviewItem] = [
        .init(id: "Label 1", imageString: "list.bullet"),
        .init(id: "Label 2", imageString: "list.bullet"),
        .init(id: "Label 3", imageString: "list.bullet"),
        .init(id: "Label 4", imageString: "list.bullet"),
    ]

    private func itemContent(_ item: PreviewItem) -> some View {
        Image(systemName: item.imageString)
            .resizable()
            .frame(width: 16, height: 12)
    }

    private func itemContentWithLabel(_ item: PreviewItem) -> some View {
        HStack {
            Text(item.id)
            Image(systemName: item.imageString)
                .resizable()
                .frame(width: 16, height: 12)
        }
    }

    struct SegmentedBetterPickerStyle_Previews: PreviewProvider {
        static var previews: some View {
            VStack {
                BetterPickerSegmented()
                BetterPickerSegmentedNoneSelected()
                ApplePickerSegmented()
                BetterPickerSegmentedCustom()
                Spacer()
            }
        }
    }

    private struct BetterPickerSegmented: View {
        @State private var selection: PreviewItem.ID? = items.first!.id

        var body: some View {
            Text("BetterPicker Segmented Picker")
            BetterPicker(items, selection: $selection, content: itemContent)
                .betterPickerStyle(
                    SegmentedBetterPickerStyle(
                        frameWidth: 260,
                        horizontalCellAlignment: .center
                    )
                )
                .padding(12)
        }
    }

    private struct BetterPickerSegmentedNoneSelected: View {
        @State private var selection: PreviewItem.ID?

        var body: some View {
            Text("BetterPicker Segmented Picker nil selection")
            BetterPicker(items, selection: $selection, content: itemContent)
                .betterPickerStyle(
                    SegmentedBetterPickerStyle(
                        frameWidth: 260,
                        horizontalCellAlignment: .center
                    )
                )
                .padding(12)
        }
    }

    private struct ApplePickerSegmented: View {
        @State private var selection: PreviewItem.ID? = items.first!.id

        var body: some View {
            Text("Apple Segmented Picker")
            Picker("Choose an option", selection: $selection) {
                ForEach(items) { item in
                    Image(systemName: item.imageString)
                        .tag(item.id)
                }
            }
            .frame(width: 150)
            .pickerStyle(SegmentedPickerStyle())
            .padding(12)
        }
    }

    private struct BetterPickerSegmentedCustom: View {
        @State private var selection: PreviewItem.ID? = items.first!.id

        var body: some View {
            Text("BetterPicker Custom Style")
            BetterPicker(items, selection: $selection, content: itemContentWithLabel)
                .betterPickerStyle(
                    SegmentedBetterPickerStyle(
                        frameWidth: 350,
                        frameHeight: 64,
                        horizontalCellAlignment: .leading
                    )
                )
                .padding(12)
        }
    }
#endif
