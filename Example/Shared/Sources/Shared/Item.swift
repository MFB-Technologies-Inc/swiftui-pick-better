// Item.swift
// PickBetter
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation

public struct Item: Identifiable, Sendable {
    public let id: Int

    public init(id: Int) {
        self.id = id
    }
}
