// ContentView.swift
// PickBetter
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import PickBetter
import SwiftUI

@MainActor
public struct ContentView: View {
    @State private var tab: TabOption = .singleValue
    @State private var isGridStyle: Bool = true
    @State private var isNavigationExpanded: Bool = true
    #if os(iOS)
        @Environment(\.horizontalSizeClass) var horizontalSizeClass
        @Environment(\.verticalSizeClass) var verticalSizeClass
    #endif
    private let items: [Item] = (0 ..< 100).map { Item(id: $0) }

    public init() {}

    public var body: some View {
        #if os(iOS)
            NavigationView {
                HStack(spacing: .zero) {
                    navigation()
                    mainBody()
                }
                .toolbar {
                    Toggle(
                        isOn: $isGridStyle,
                        label: { Text(isGridStyle ? "Grid Style" : "List Style") }
                    )
                    .accessibilityIdentifier(gridStyleToggle)
                }
                .navigationBarTitleDisplayMode(.inline)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        #elseif os(macOS)
            NavigationView {
                navigation()
            }
            .toolbar {
                Toggle(
                    isOn: $isGridStyle,
                    label: { Text(isGridStyle ? "Grid Style" : "List Style") }
                )
                .accessibilityIdentifier(gridStyleToggle)
            }
        #elseif os(tvOS)
            navigation()
        #endif
    }

    // MARK: Accessibility Ids

    private var gridStyleToggle: String { "gridStyleToggle" }
    private var singleSectionNavItem: String { "singleValueSectionNavItem" }
    private var singleOptionalSectionNavItem: String { "singleOptionalValueSectionNavItem" }
    private var multiSectionNavItem: String { "multiValueSectionNavItem" }

    // MARK: Content

    private func singleValue() -> some View {
        SingleValueSelection(items: items, isGridStyle: isGridStyle)
    }

    private var singleValueNavLabel: some View {
        #if os(iOS)
            Image(systemName: "1.circle")
        #elseif os(macOS) || os(tvOS)
            HStack {
                Image(systemName: "1.circle")
                Text("Single Value")
            }
            .font(.title)
        #endif
    }

    private func singleOptionalValue() -> some View {
        SingleOptionalValueSelection(items: items, isGridStyle: isGridStyle)
    }

    private var singleOptionalValueNavLabel: some View {
        #if os(iOS)
            Image(systemName: "questionmark.circle")
        #elseif os(macOS) || os(tvOS)
            HStack {
                Image(systemName: "questionmark.circle")
                Text("Single Optional Value")
            }
            .font(.title)
        #endif
    }

    private func multiValue() -> some View {
        MultiValueSelection(items: items, isGridStyle: isGridStyle)
    }

    private var multiValueNavLabel: some View {
        #if os(iOS)
            Image(systemName: "n.circle")
        #elseif os(macOS) || os(tvOS)
            HStack {
                Image(systemName: "n.circle")
                Text("Multi Value")
            }
            .font(.title)
        #endif
    }

    private func navigationButton<Label>(label: Label, tag: TabOption, id: String) -> some View where Label: View {
        accessibleNavigation(tag: tag, id: id) {
            #if os(iOS)
                Toggle(
                    isOn: Binding(
                        get: { tab == tag },
                        set: { isOn, _ in
                            if isOn {
                                tab = tag
                            }
                        }
                    ),
                    label: { label.scaledToFill() }
                )
                .toggleStyle(BackPortedButtonToggleStyle())
                .frame(height: 75)
            #elseif os(macOS)
                NavigationLink(
                    tag: tag,
                    selection: Binding($tab),
                    destination: mainBody,
                    label: { label.scaledToFill() }
                )
            #elseif os(tvOS)
                EmptyView()
            #endif
        }
    }

    private func accessibleNavigation<Content>(
        tag: TabOption,
        id: String,
        @ViewBuilder _ content: @escaping () -> Content
    ) -> some View where Content: View {
        content()
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(sectionOptionAccessibilityTraitsToAdd(isSelected: tab == tag))
            .accessibilityRemoveTraits(sectionOptionAccessibilityTraitsToRemove(isSelected: tab == tag))
            .accessibilityIdentifier(id)
    }

    private func navigation() -> some View {
        #if os(iOS)
            VStack(alignment: .center) {
                navigationButton(label: singleValueNavLabel, tag: .singleValue, id: singleSectionNavItem)
                navigationButton(
                    label: singleOptionalValueNavLabel,
                    tag: .singleOptionalValue,
                    id: singleOptionalSectionNavItem
                )
                navigationButton(label: multiValueNavLabel, tag: .multiValue, id: multiSectionNavItem)
                Spacer()
            }
            .frame(width: 75)
        #elseif os(macOS)
            List {
                navigationButton(label: singleValueNavLabel, tag: .singleValue, id: singleSectionNavItem)
                navigationButton(
                    label: singleOptionalValueNavLabel,
                    tag: .singleOptionalValue,
                    id: singleOptionalSectionNavItem
                )
                navigationButton(label: multiValueNavLabel, tag: .multiValue, id: multiSectionNavItem)
            }
        #elseif os(tvOS)
            TabView {
                singleValue()
                    .tabItem {
                        accessibleNavigation(tag: .singleValue, id: singleSectionNavItem) { singleValueNavLabel }
                    }
                singleOptionalValue()
                    .tabItem {
                        accessibleNavigation(tag: .singleOptionalValue, id: singleOptionalSectionNavItem) {
                            singleOptionalValueNavLabel
                        }
                    }
                multiValue()
                    .tabItem { accessibleNavigation(tag: .multiValue, id: multiSectionNavItem) { multiValueNavLabel } }
            }
        #endif
    }

    private func mainBody() -> some View {
        Group {
            switch tab {
            case .singleValue:
                singleValue()
            case .singleOptionalValue:
                singleOptionalValue()
            case .multiValue:
                multiValue()
            }
            Spacer()
        }
    }

    // MARK: Accessibility Traits

    private func sectionOptionAccessibilityTraitsToAdd(isSelected: Bool) -> AccessibilityTraits {
        if isSelected {
            return .isSelected
        } else {
            return []
        }
    }

    private func sectionOptionAccessibilityTraitsToRemove(isSelected: Bool) -> AccessibilityTraits {
        if isSelected {
            return []
        } else {
            return .isSelected
        }
    }
}
