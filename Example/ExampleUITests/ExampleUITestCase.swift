// ExampleUITestCase.swift
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
class ExampleUITestCase: XCUITestCase {
    var _sectionNavItem: (@MainActor () throws -> XCUIElement)? {
        nil
    }

    func sectionNavItem() throws -> XCUIElement {
        try XCTUnwrap(_sectionNavItem)()
    }

    var _picker: (@MainActor () throws -> XCUIElement)? {
        nil
    }

    func picker() throws -> XCUIElement {
        try XCTUnwrap(_picker)()
    }

    override func setUpWithError() throws {
        try super.setUpWithError()

        #if os(iOS)
            // iPad has a bug where view is blank when starting in portrait
            // Let's rotate it landscape and back to work around that bug.
            Task { @MainActor in
                XCUIDevice.shared.orientation = .portrait
                XCUIDevice.shared.orientation = .landscapeRight
                XCUIDevice.shared.orientation = .portrait
            }
        #endif
    }

    func gridStyleToggle() throws -> XCUIElement {
        try allElements().matching(identifier: "gridStyleToggle").firstMatch
    }

    func isGridStyleSelected() throws -> Bool {
        try gridStyleToggle().label == "Grid Style"
    }

    func setGridStyle() throws {
        if try !isGridStyleSelected() {
            try gridStyleToggle().trigger()
        }
        XCTAssert(try isGridStyleSelected())
    }

    func setListStyle() throws {
        if try isGridStyleSelected() {
            try gridStyleToggle().trigger()
        }
        XCTAssert(try !isGridStyleSelected())
    }

    func singleValueNavItem() throws -> XCUIElement {
        try allElements().matching(identifier: "singleValueSectionNavItem").firstMatch
    }

    func singleOptionalValueNavItem() throws -> XCUIElement {
        try allElements().matching(identifier: "singleOptionalValueSectionNavItem").firstMatch
    }

    func multiValueNavItem() throws -> XCUIElement {
        try allElements().matching(identifier: "multiValueSectionNavItem").firstMatch
    }

    func segmentedNavItem() throws -> XCUIElement {
        try allElements().matching(identifier: "segmentedNavItem").firstMatch
    }

    func singleValuePicker() throws -> XCUIElement {
        try allElements().matching(identifier: "singleValuePicker").exactlyOneMatch()
    }

    func singleOptionalValuePicker() throws -> XCUIElement {
        try allElements().matching(identifier: "singleOptionalValuePicker").exactlyOneMatch()
    }

    func multiValuePicker() throws -> XCUIElement {
        try allElements().matching(identifier: "multiValuePicker").exactlyOneMatch()
    }

    func segmentedPicker() throws -> XCUIElement {
        try allElements().matching(identifier: "segmentedPicker").firstMatch
    }

    func segmentedButtonZero() throws -> XCUIElement {
        try allElements().children(matching: .button)
            .element(matching: elementCompoundOrPredicate(labeled: ["Segmented 0"]))
    }

    func segmentedButtonOne() throws -> XCUIElement {
        try allElements().children(matching: .button)
            .element(matching: elementCompoundOrPredicate(labeled: ["Segmented 1"]))
    }

    func segmentedButtonTwo() throws -> XCUIElement {
        try allElements().children(matching: .button)
            .element(matching: elementCompoundOrPredicate(labeled: ["Segmented 2"]))
    }

    func cellZero() throws -> XCUIElement {
        try allElements().children(matching: .cell)
            .element(matching: elementCompoundOrPredicate(labeled: ["Cell - 0", "Cell - 0, Selected"]))
    }

    func buttonZero() throws -> XCUIElement {
        try allElements().children(matching: .button)
            .element(matching: elementCompoundOrPredicate(labeled: ["Cell - 0", "Cell - 0, Selected"]))
    }

    func cellOne() throws -> XCUIElement {
        try allElements().children(matching: .cell)
            .element(matching: elementCompoundOrPredicate(labeled: ["Cell - 1", "Cell - 1, Selected"]))
    }

    func buttonOne() throws -> XCUIElement {
        try allElements().children(matching: .button)
            .element(matching: elementCompoundOrPredicate(labeled: ["Cell - 1", "Cell - 1, Selected"]))
    }

    func button(_ buttonNumber: Int) throws -> XCUIElement {
        try allElements().children(matching: .button)
            .element(matching: elementCompoundOrPredicate(labeled: [
                "Cell - \(buttonNumber)",
                "Cell - \(buttonNumber), Selected",
            ]))
    }
}
