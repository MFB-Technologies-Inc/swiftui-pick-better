// SingleOptionalValueTests.swift
// PickBetter
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import XCTest
#if os(iOS)
    import Example
#elseif os(macOS)
    import Example_macOS
#endif

@MainActor
final class SingleOptionalValueUITests: ExampleUITestCase {
    @MainActor
    override var _sectionNavItem: (@MainActor () throws -> XCUIElement)? {
        singleOptionalValueNavItem
    }

    @MainActor
    override var _picker: (@MainActor () throws -> XCUIElement)? {
        singleOptionalValuePicker
    }

    func sharedTestSteps() throws {
        _ = try gridStyleToggle().waitForExistence(timeout: 1)
        try setGridStyle()

        _ = try sectionNavItem().waitForExistence(timeout: 1)
        XCTAssert(try sectionNavItem().exists, "Navigation link/tab for 'Single' value picker must exist")
        try sectionNavItem().trigger()

        _ = try picker().waitForExistence(timeout: 1)
        XCTAssert(try picker().exists, "Single value picker must exist")
        _ = try buttonZero().waitForExistence(timeout: 1)
        _ = try buttonOne().waitForExistence(timeout: 1)
        XCTAssert(try buttonZero().exists, "Button Zero must exist")
        XCTAssert(try buttonOne().exists, "Button One must exist")
        XCTAssert(
            try !buttonZero().isSelected && (!buttonOne().isSelected),
            "Initial state should have no item selected"
        )

        try buttonZero().trigger()
        XCTAssert(try buttonZero().isSelected, "'0' should be selected after being tapped")
        XCTAssert(try !buttonOne().isSelected, "'1' should not be selected after '0' is tapped.")

        try buttonZero().trigger()
        XCTAssert(try !buttonZero().isSelected, "'0' should no longer be selected after being tapped while selected")
        XCTAssert(try !buttonOne().isSelected, "'1' should not be selected before being tapped.")

        try buttonOne().trigger()
        XCTAssert(try !buttonZero().isSelected, "'0' should no longer be selected after tapping a new item.")
        XCTAssert(try buttonOne().isSelected, "'1' should be selected after it is tapped.")
    }

    func testGridStyleDeselectAndSelectNew() async throws {
        _ = try gridStyleToggle().waitForExistence(timeout: 1)
        try setGridStyle()

        try sharedTestSteps()
    }

    func testListStyleDeselectAndSelectNew() async throws {
        _ = try gridStyleToggle().waitForExistence(timeout: 1)
        try setListStyle()

        try sharedTestSteps()
    }
}
