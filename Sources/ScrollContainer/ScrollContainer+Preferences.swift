//
//  ScrollContainer+Preferences.swift
//  ScrollContainer
//
//  Created by Ben Gottlieb on 10/29/23.
//

import SwiftUI
import Suite

struct ScrollContainerVisibleRectPreferenceKey: PreferenceKey {
	static func reduce(value: inout UnitRect?, nextValue: () -> UnitRect?) {
		value = nextValue() ?? value
	}
}

struct ScrollContainerProxyBindingEnvironmentKey: EnvironmentKey {
	static var defaultValue = Binding.constant(ScrollContainerProxy())
}

extension EnvironmentValues {
	var scrollContainerProxyBinding: Binding<ScrollContainerProxy> {
		get { self[ScrollContainerProxyBindingEnvironmentKey.self] }
		set { self[ScrollContainerProxyBindingEnvironmentKey.self] = newValue }
	}
}
