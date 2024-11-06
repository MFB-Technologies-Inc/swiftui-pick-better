// SegmentedUITests.swift
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

final class SegmentedUITests: ExampleUITestCase {
    @MainActor
    override var _sectionNavItem: (@MainActor () throws -> XCUIElement)? {
        segmentedNavItem
    }

    @MainActor
    override var _picker: (@MainActor () throws -> XCUIElement)? {
        segmentedPicker
    }

    func testSelectSegmentedPickerItems() async throws {
        _ = try sectionNavItem().waitForExistence(timeout: 1)
        XCTAssert(try sectionNavItem().exists, "Navigation link/tab for 'Segmented' picker must exist")
        try sectionNavItem().trigger()

        _ = try picker().waitForExistence(timeout: 1)
        XCTAssert(try picker().exists, "Segmented picker must exist")
        _ = try segmentedButtonZero().waitForExistence(timeout: 1)
        _ = try segmentedButtonOne().waitForExistence(timeout: 1)

        XCTAssert(try segmentedButtonZero().exists, "Cell Zero must exist")
        XCTAssert(try segmentedButtonOne().exists, "Cell One must exist")
        XCTAssert(
            try segmentedButtonZero().isSelected && (!segmentedButtonOne().isSelected),
            "Initial state should have cell Zero selected"
        )

        try segmentedButtonOne().trigger()
        XCTAssert(try segmentedButtonOne().isSelected, "'1' should be selected after being tapped")
        XCTAssert(try !segmentedButtonZero().isSelected, "'0' should not be selected before being tapped.")

        try segmentedButtonTwo().trigger()
        XCTAssert(
            try segmentedButtonTwo().isSelected,
            "'2' should still be selected without being tapped again to deselect"
        )
        XCTAssert(try !segmentedButtonOne().isSelected, "'1' should be selected after being tapped.")

        try segmentedButtonOne().trigger()
        XCTAssert(
            try segmentedButtonOne().isSelected,
            "'1' should still be selected without being tapped again to deselect"
        )
        XCTAssert(
            try !segmentedButtonTwo().isSelected,
            "'2' should no longer be selected after being tapped again to deselect"
        )
    }
}
