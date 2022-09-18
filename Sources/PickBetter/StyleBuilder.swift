// StyleBuilder.swift
// PickBetter
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import SwiftUI

/// `resultBuilder` implementation for `BetterPickerStyle` that enables convenient choosing of a style in logic without causing problems with different types.
@MainActor
@resultBuilder
public enum StyleBuilder {
    public static func buildBlock<Style: BetterPickerStyle>(_ style: Style) -> Style {
        style
    }

    public static func buildIf<Style: BetterPickerStyle>(_ style: Style?) -> Style? {
        style
    }

    public static func buildEither<TrueStyle, FalseStyle>(first: TrueStyle) -> _ConditionalStyle<TrueStyle, FalseStyle>
        where TrueStyle: BetterPickerStyle, FalseStyle: BetterPickerStyle
    {
        _ConditionalStyle(trueStyle: first)
    }

    public static func buildEither<
        TrueStyle,
        FalseStyle
    >(second: FalseStyle) -> _ConditionalStyle<TrueStyle, FalseStyle> where TrueStyle: BetterPickerStyle,
        FalseStyle: BetterPickerStyle
    {
        _ConditionalStyle(falseStyle: second)
    }

    /// Wrapper for conditional application of two styles.
    @MainActor
    public struct _ConditionalStyle<TrueStyle, FalseStyle>: BetterPickerStyle where TrueStyle: BetterPickerStyle,
        FalseStyle: BetterPickerStyle
    {
        private let _trueStyle: TrueStyle?
        private let _falseStyle: FalseStyle?

        init(trueStyle: TrueStyle) {
            _trueStyle = trueStyle
            _falseStyle = nil
        }

        init(falseStyle: FalseStyle) {
            _trueStyle = nil
            _falseStyle = falseStyle
        }

        @ViewBuilder
        public func makeView(_ configuration: Configuration) -> some View {
            if let trueStyle = _trueStyle {
                trueStyle.makeView(configuration)
            } else if let falseStyle = _falseStyle {
                falseStyle.makeView(configuration)
            } else {
                // This should never occur
                EmptyView()
            }
        }

        @ViewBuilder
        public func makeListCell(_ configuration: CellConfiguration) -> some View {
            if let trueStyle = _trueStyle {
                trueStyle.makeListCell(configuration)
            } else if let falseStyle = _falseStyle {
                falseStyle.makeListCell(configuration)
            } else {
                // This should never occur
                EmptyView()
            }
        }
    }
}
