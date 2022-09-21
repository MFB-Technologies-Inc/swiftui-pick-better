// BackPortedButtonToggleStyle.swift
// PickBetter
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import SwiftUI

@MainActor
public struct BackPortedButtonToggleStyle: ToggleStyle {
    public func makeBody(configuration: Configuration) -> some View {
        Button(
            action: { configuration.$isOn.wrappedValue.toggle() },
            label: {
                ZStack {
                    if configuration.isOn {
                        Color.secondary
                    } else {
                        Color.clear
                    }
                    configuration.label
                        .foregroundColor(configuration.isOn ? .primary : .secondary)
                }
            }
        )
    }
}
