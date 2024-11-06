// SegmentedBetterPickerStyle.swift
// PickBetter
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import SwiftUI

/// 'Segmented' style that mimics Apple's PickerStyle.segmented
public struct SegmentedBetterPickerStyle: BetterPickerStyle {
    /// Width of the entire Picker. Required property in order to calculate cell size correctly.
    private var frameWidth: CGFloat
    /// Height of the entire Picker. Defaults to '32', the same height used in Apple's segmented Picker.
    private var frameHeight: CGFloat
    /// Horizontal alignment for the inner ``View`` of the cells. Defaults to ``.center`` alignment.
    private var horizontalCellAlignment: HorizontalAlignment

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
        /// Full width of the `View` for a cell.
        let cellWidth = (frameWidth / CGFloat(configuration.cellCount)) - 1.5
        /// Index of the selected cell.
        let selectCellIndex = configuration.selectionIndexSet.first

        ZStack(alignment: .leading) {
            if let selectCellIndex = selectCellIndex {
                /// Rounded background to display selected item
                RoundedRectangle(cornerRadius: 6)
                    .fill(.white)
                    .frame(width: cellWidth, height: frameHeight)
                    .offset(x: CGFloat(selectCellIndex) * cellWidth)
                    .animation(.easeInOut(duration: 0.25), value: selectCellIndex)
                    .padding(2)
                    .shadow(color: .secondary.opacity(0.3), radius: 2, y: 1)
            }

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
