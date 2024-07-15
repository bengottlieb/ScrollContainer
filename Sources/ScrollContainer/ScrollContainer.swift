//
//  ScrollContainer.swift
//  ScrollContainer
//
//  Created by Ben Gottlieb on 10/29/23.
//

import SwiftUI
import Suite

#if os(iOS)
struct ScrollContainer<Content: View>: UIViewRepresentable {
	var focus: ScrollFocusInfo
	let contentSize: CGSize
	var maximumScale = 2.0
	let indicators: VisibleScrollIndicators
	var delaysContentTouches = false
	var scrollEnabled = true
	var backgroundColor: Color
	var toFit = false
	@ViewBuilder let content: () -> Content
	
	@Environment(\.scrollContainerProxyBinding) var scrollContainerProxyBinding
	
	public init(scrollEnabled: Bool = true, contentSize: CGSize, backgroundColor: Color = .black, maximimumScale: Double = 2.0, delaysContentTouches: Bool = true, focus: ScrollFocusInfo = .init(), indicators: VisibleScrollIndicators = .all, toFit: Bool = false, @ViewBuilder content: @escaping () -> Content) {
		self.focus = focus
		self.contentSize = contentSize
		self.maximumScale = maximimumScale
		self.content = content
		self.indicators = indicators
		self.delaysContentTouches = delaysContentTouches
		self.scrollEnabled = scrollEnabled
		self.backgroundColor = backgroundColor
		self.toFit = toFit
	}
	
	func makeUIView(context: Context) -> some UIView {
		context.coordinator.scrollView
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) {
		context.coordinator.scrollEnabled = scrollEnabled
		context.coordinator.scrollTo(focus: focus)
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(scrollEnabled: scrollEnabled, contentSize: contentSize, backgroundColor: backgroundColor, maximumScale: maximumScale, delaysContentTouches: delaysContentTouches, focus: focus, proxy: scrollContainerProxyBinding, indicators: indicators, toFit: toFit, content: content)
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

#endif
