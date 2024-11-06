// XCUIElement+Trigger.swift
// PickBetter
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import XCTest

extension XCUIElement {
    func trigger() {
        #if os(iOS) || os(watchOS)
            tap()
        #elseif os(macOS)
            click()
        #elseif os(tvOS)
            XCUIRemote.shared.press(.select)
        #endif
    }

    func details() throws -> String {
        guard identifier.isEmpty else {
            return identifier
        }
        guard label.isEmpty else {
            return label
        }
        return debugDescription
    }
}
