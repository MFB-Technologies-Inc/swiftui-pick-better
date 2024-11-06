// SingleValueUITests.swift
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
final class SingleValueUITests: ExampleUITestCase {
    @MainActor
    override var _sectionNavItem: (@MainActor () throws -> XCUIElement)? {
        singleValueNavItem
    }

    @MainActor
    override var _picker: (@MainActor () throws -> XCUIElement)? {
        singleValuePicker
    }

    func sharedTestSteps() throws {
        _ = try sectionNavItem().waitForExistence(timeout: 1)
        XCTAssert(try sectionNavItem().exists, "Navigation link/tab for 'Single' value picker must exist")
        #if os(tvOS)
            guard try findVertically(sectionNavItem(), method: .upOnly) else {
                XCTFail("Failed to find navigation picker")
                return
            }
        #endif
        try sectionNavItem().trigger()

        _ = try picker().waitForExistence(timeout: 1)
        XCTAssert(try picker().exists, "Single value picker must exist")
        _ = try buttonZero().waitForExistence(timeout: 1)
        _ = try buttonOne().waitForExistence(timeout: 1)
        XCTAssert(try buttonZero().exists, "Button Zero must exist")
        XCTAssert(try buttonOne().exists, "Button One must exist")
        XCTAssert(try buttonZero().isSelected, "Initial state should have the first item selected which is '0'")

        #if os(tvOS)
            guard try findVertically(button(3), method: .downOnly) else {
                XCTFail("Failed to find '3' to select it.")
                return
            }
            guard try findHorizontally(buttonZero(), method: .leftOnly) else {
                XCTFail("Failed to find '0'")
                return
            }
        #endif
        try buttonZero().trigger()
        XCTAssert(try buttonZero().isSelected, "The 'Single' value picker does not allow de-selecting.")
        XCTAssert(try !buttonOne().isSelected, "'1' should not be selected before being tapped.")

        #if os(tvOS)
            guard try findHorizontally(buttonOne(), method: .rightOnly) else {
                XCTFail("Failed to find '1' to select it.")
                return
            }
        #endif
        try buttonOne().trigger()
        XCTAssert(try !buttonZero().isSelected, "'0' should no longer be selected after tapping a new item.")
        XCTAssert(try buttonOne().isSelected, "'1' should be selected after it is tapped.")
        XCTAssert(try !buttonZero().isSelected, "'0' should no longer be selected after tapping a new item.")
    }

    func testGridStyleDeselectAndSelectNew() async throws {
        _ = try gridStyleToggle().waitForExistence(timeout: 1)
        #if os(tvOS)
            guard try findVertically(gridStyleToggle(), method: .downOnly) else {
                XCTFail("Failed to find grid toggle")
                return
            }
        #endif
        try setGridStyle()

        try sharedTestSteps()
    }

    func testListStyleDeselectAndSelectNew() async throws {
        _ = try gridStyleToggle().waitForExistence(timeout: 1)
        #if os(tvOS)
            guard try findVertically(gridStyleToggle(), method: .downOnly) else {
                XCTFail("Failed to find grid toggle")
                return
            }
        #endif
        try setListStyle()

        try sharedTestSteps()
    }
}
