// RouteView.swift
// PickBetter
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import SwiftUI

@MainActor
public struct RouterView<Links, Content>: View where Links: View, Content: View {
    @Binding private var selection: AnyHashable
    private let links: (Binding<AnyHashable>) -> Links
    private let content: (Binding<AnyHashable>) -> Content

    public init(
        selection: Binding<AnyHashable>,
        links: @escaping (Binding<AnyHashable>) -> Links,
        @ViewBuilder content: @escaping (Binding<AnyHashable>) -> Content
    ) {
        _selection = selection
        self.links = links
        self.content = content
    }

    public init<T>(
        selection: Binding<T>,
        links: @escaping (Binding<AnyHashable>) -> Links,
        @ViewBuilder content: @escaping (Binding<AnyHashable>) -> Content
    ) where T: Hashable {
        _selection = Binding(selection)
        self.links = links
        self.content = content
    }

    public var body: some View {
        content($selection)
    }
}

@MainActor
public struct RouteView<Route, Label, Destination>: View where Route: Hashable, Label: View, Destination: View {
    private let route: AnyHashable
    @Binding private var selection: AnyHashable
    private let label: () -> Label
    private let destination: () -> Destination

    public init(
        route: AnyHashable,
        selection: Binding<AnyHashable>,
        label: @escaping () -> Label,
        destination: @escaping () -> Destination
    ) {
        self.route = route
        _selection = selection
        self.label = label
        self.destination = destination
    }

    public var body: some View {
        Button(action: { selection = route }, label: label)
    }
}
