// XCUITestCase.swift
// PickBetter
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import XCTest

@MainActor
class XCUITestCase: XCTestCase {
    private var _app: XCUIApplication?

    func app() throws -> XCUIApplication {
        try XCTUnwrap(_app)
    }

    func allElements() throws -> XCUIElementQuery {
        try app().descendants(matching: .any)
    }

    func elementPredicate(labeled label: String) -> NSPredicate {
        NSComparisonPredicate(
            leftExpression: NSExpression(forKeyPath: \XCUIElement.label),
            rightExpression: NSExpression(forConstantValue: label),
            modifier: .direct,
            type: .equalTo,
            options: []
        )
    }

    func elementCompoundOrPredicate(labeled labels: Set<String>) -> NSPredicate {
        let subpredicates = labels.map { label in
            elementPredicate(labeled: label)
        }
        return NSCompoundPredicate(orPredicateWithSubpredicates: subpredicates)
    }

    override func setUp() async throws {
        Task { @MainActor in
            self._app = XCUIApplication()
            self.continueAfterFailure = false
            try? self.app().launch()
        }
    }
}

#if os(iOS) || os(tvOS)
    extension XCUITestCase {
        var focusPredicate: NSPredicate {
            NSComparisonPredicate(
                leftExpression: NSExpression(forKeyPath: \XCUIElement.hasFocus),
                rightExpression: NSExpression(forConstantValue: true),
                modifier: .direct,
                type: .equalTo,
                options: []
            )
        }

        @MainActor
        func currentFocus() throws -> XCUIElement {
            try allElements().descendants(matching: .any).element(matching: focusPredicate)
        }
    }
#endif

#if os(tvOS)
    enum VerticalFocusSearchMethod {
        case downFirst
        case upFirst
        case downOnly
        case upOnly

        var singleDirection: Bool {
            self == .downOnly || self == .upOnly
        }

        var firstDirection: FocusMoveDirection {
            switch self {
            case .downOnly, .downFirst:
                return .down
            case .upOnly, .upFirst:
                return .up
            }
        }
    }

    enum HorizontalFocusSearchMethod {
        case rightFirst
        case leftFirst
        case rightOnly
        case leftOnly

        var singleDirection: Bool {
            self == .rightOnly || self == .leftOnly
        }

        var firstDirection: FocusMoveDirection {
            switch self {
            case .rightOnly, .rightFirst:
                return .right
            case .leftOnly, .leftFirst:
                return .left
            }
        }
    }

    enum FocusMoveDirection {
        case up
        case down
        case left
        case right

        func invert() -> Self {
            switch self {
            case .up:
                return .down
            case .down:
                return .up
            case .left:
                return .right
            case .right:
                return .left
            }
        }

        func progressForGridSearch() -> Self {
            switch self {
            case .up:
                return .left
            case .down:
                return .right
            case .left:
                return .up
            case .right:
                return .down
            }
        }
    }

    extension FocusMoveDirection {
        var remoteDirection: XCUIRemote.Button {
            switch self {
            case .up:
                return .up
            case .down:
                return .down
            case .left:
                return .left
            case .right:
                return .right
            }
        }
    }

    extension XCUITestCase {
        func findVertically(_ element: XCUIElement, method: VerticalFocusSearchMethod) throws -> Bool {
            var isEndReached = false
            var currentDirection: FocusMoveDirection = method.firstDirection
            while !element.exists || !element.hasFocus {
                let previous: String = try currentFocus().details()
                moveFocus(direction: currentDirection)
                let current: String = try currentFocus().details()
                if previous == current {
                    if isEndReached || method.singleDirection {
                        return false
                    }
                    isEndReached = true
                    currentDirection = currentDirection.invert()
                }
            }
            return true
        }

        func findHorizontally(_ element: XCUIElement, method: HorizontalFocusSearchMethod) throws -> Bool {
            var isEndReached = false
            var currentDirection: FocusMoveDirection = method.firstDirection
            while !element.exists || !element.hasFocus {
                let previous: String = try currentFocus().details()
                moveFocus(direction: currentDirection)
                let current: String = try currentFocus().details()
                if previous == current {
                    if isEndReached || method.singleDirection {
                        return false
                    }
                    isEndReached = true
                    currentDirection = currentDirection.invert()
                }
            }
            return true
        }

        func findInGrid(_ element: XCUIElement, firstDirection: FocusMoveDirection) throws -> Bool {
            var isEndReached = false
            var currentDirection: FocusMoveDirection = firstDirection
            while !element.exists || !element.hasFocus {
                let previous: String = try currentFocus().details()
                moveFocus(direction: currentDirection)
                let current: String = try currentFocus().details()
                if previous == current {
                    if isEndReached {
                        return false
                    }
                    isEndReached = true
                    currentDirection = currentDirection.progressForGridSearch()
                }
            }
            return true
        }

        func moveFocus(direction: FocusMoveDirection) {
            XCUIRemote.shared.press(direction.remoteDirection)
        }
    }
#endif
