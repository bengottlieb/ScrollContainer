//
//  ScrollContainer.swift
//  ScrollContainer
//
//  Created by Ben Gottlieb on 10/29/23.
//

import SwiftUI
import Suite

struct ScrollContainer<Content: View>: UIViewRepresentable {
	var focus: FocusInfo
	let contentSize: CGSize
	var maximumScale = 1.0
	@ViewBuilder let content: () -> Content
	
	@Environment(\.scrollContainerProxyBinding) var scrollContainerProxyBinding
	
	public init(contentSize: CGSize, maximimumScale: Double = 1.0, focus: FocusInfo = .init(), @ViewBuilder content: @escaping () -> Content) {
		self.focus = focus
		self.contentSize = contentSize
		self.maximumScale = maximimumScale
		self.content = content
	}
	
	func makeUIView(context: Context) -> some UIView {
		context.coordinator.scrollView
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) {
		context.coordinator.scrollTo(focus: focus)
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(contentSize: contentSize, maximumScale: maximumScale, focus: focus, proxy: scrollContainerProxyBinding, content: content)
	}
}

struct FixedSize<Content: View>: View {
	let size: CGSize
	@ViewBuilder let content: () -> Content
	
	var body: some View {
		content()
			.frame(width: size.width, height: size.height)
	}
}

