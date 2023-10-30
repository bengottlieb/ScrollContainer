//
//  ScrollContainerReader.swift
//  ScrollContainer
//
//  Created by Ben Gottlieb on 10/30/23.
//

import SwiftUI
import Suite

public struct ScrollContainerProxy {
	public var visibleUnitRect: UnitRect = .full
}


public struct ScrollContainerReader<Content: View>: View {
	@ViewBuilder let content: (ScrollContainerProxy) -> Content
	
	@State private var proxy = ScrollContainerProxy()
	
	public init(@ViewBuilder content: @escaping (ScrollContainerProxy) -> Content) {
		self.content = content
	}
	
	public var body: some View {
		content(proxy)
			.environment(\.scrollContainerProxyBinding, $proxy)
	}
}
