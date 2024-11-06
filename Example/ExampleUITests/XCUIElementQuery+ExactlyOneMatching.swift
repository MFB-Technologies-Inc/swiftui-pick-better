// XCUIElementQuery+ExactlyOneMatching.swift
// PickBetter
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import XCTest

extension XCUIElementQuery {
    @MainActor
    public func exactlyOneMatch() throws -> XCUIElement {
        XCTAssertEqual(count, 1, "Requiring only one element match the query resulting in `self`")
        return firstMatch
    }
}
