// GridBetterPickerStyle.swift
// PickBetter
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import PickBetter
import SwiftUI

public struct GridBetterPickerStyle: BetterPickerStyle {
    let color: Color

    public init(color: Color) {
        self.color = color
    }

    public func makeView(_ configuration: Configuration) -> some View {
        ScrollView {
            LazyVGrid(columns: gridItems(count: configuration.cellCount), spacing: gridSpacing) {
                configuration.listOutput
            }
        }
    }

    private var gridSpacing: CGFloat {
        #if os(tvOS)
            16
        #else
            8
        #endif
    }

    private var minimumWidth: CGFloat {
        #if os(iOS)
            80
        #elseif os(macOS)
            150
        #elseif os(tvOS)
            200
        #else
            80
        #endif
    }

    private var maximumWidth: CGFloat {
        #if os(iOS)
            100
        #elseif os(macOS)
            250
        #elseif os(tvOS)
            300
        #else
            100
        #endif
    }

    private func gridItems(count _: Int) -> [GridItem] {
        [GridItem(.adaptive(minimum: minimumWidth, maximum: maximumWidth))]
    }

    public func makeListCell(_ configuration: CellConfiguration) -> some View {
        Button(action: configuration.trigger, label: {
            ZStack {
                if configuration.isSelected() {
                    Color.accentColor
                } else {
                    color
                }
                configuration.label()
                    .foregroundColor(configuration.isSelected() ? .primary : .accentColor)
            }
        })
    }
}
