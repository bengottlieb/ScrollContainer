//
//  ScrollContainer+Coordinator.swift
//  ScrollContainer
//
//  Created by Ben Gottlieb on 10/29/23.
//

import SwiftUI
import Suite

extension ScrollContainer {
	class Coordinator: NSObject, UIScrollViewDelegate {
		let content: () -> Content
		let maximumScale: Double
		var scrollView: ContainerScrollView!
		var controller: UIHostingController<FixedSize<Content>>!
		var focus: ScrollFocusInfo
		var scrollContainerProxyBinding: Binding<ScrollContainerProxy>
		var indicators: VisibleScrollIndicators
		var initialZoomAspect = ContentMode.fill
		var currentZoomAspect: ContentMode?
		
		init(contentSize: CGSize, maximumScale: Double, focus: ScrollFocusInfo, proxy: Binding<ScrollContainerProxy>, indicators: VisibleScrollIndicators, content: @escaping () -> Content) {
			self.content = content
			self.scrollContainerProxyBinding = proxy
			self.maximumScale = maximumScale
			self.focus = focus
			self.indicators = indicators
			super.init()

			controller = UIHostingController(rootView: FixedSize(size: contentSize, content: content))
			
			scrollView = ContainerScrollView()
			scrollView.coordinator = self
			scrollView.showsHorizontalScrollIndicator = indicators.contains(.horizontal)
			scrollView.showsVerticalScrollIndicator = indicators.contains(.vertical)
			scrollView.backgroundColor = .gray
			scrollView.keyboardDismissMode = .none
			scrollView.delegate = self
			controller.view.frame = CGRect(origin: .zero, size: contentSize)
			scrollView.addSubview(controller.view)
			scrollView.contentSize = contentSize
		//	scrollView.zoomScale = 1 / maximumScale
			scrollView.maximumZoomScale = maximumScale
		}
		
		func updateContentMode() {
			guard scrollView.frame.width > 0 else { return }
			if currentZoomAspect == nil {
				switch initialZoomAspect {
				case .fit:
					currentZoomAspect = .fit
					scrollView.scaleToFit()
					scrollView.contentOffset = .zero
				case .fill:
					currentZoomAspect = .fill
					scrollView.scaleToFill()
					scrollView.contentOffset = .zero
				}
				updateOffsets()
			}
		}
		
		func viewForZooming(in scrollView: UIScrollView) -> UIView? {
			controller.view
		}
		
		func scrollViewDidZoom(_ scrollView: UIScrollView) { updateOffsets() }
		func scrollViewDidScroll(_ scrollView: UIScrollView) { updateOffsets() }
		func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
			updateOffsets()
		}
		func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
			updateOffsets()
		}
		
		func updateOffsets() {
			var offset = scrollView.contentOffset
			let size = scrollView.contentSize
			let bounds = scrollView.bounds
			if size.width < bounds.width {
				offset.x = -(bounds.width - size.width) / 2
			}
			if size.height < bounds.height {
				offset.y = -(bounds.height - size.height) / 2
			}
			
			if offset != scrollView.contentOffset {
				scrollView.contentOffset = offset
			}
			
			DispatchQueue.main.async {
				self.scrollContainerProxyBinding.wrappedValue.visibleUnitRect = self.scrollView.visibleUnitRect
				self.scrollContainerProxyBinding.wrappedValue.contentOffset = self.scrollView.contentOffset
				self.scrollContainerProxyBinding.wrappedValue.zoomScale = self.scrollView.zoomScale
			}
		}
	}
}

extension ScrollContainer.Coordinator {
	func scrollTo(focus: ScrollFocusInfo, animationDuration: TimeInterval = 0.2) {
		print("Re-focusing: \(focus.center?.description ?? "--"), \(focus.visible?.description ?? "--")")
		UIView.animate(withDuration: animationDuration) { [unowned self] in
			if let center = focus.center, center != self.focus.center {
				self.focus = focus
				refocus(on: center, resize: false)
			}
		}
	}

	func refocus(on unitRect: UnitRect, resize: Bool = false) {
		if scrollView.visibleUnitRect.contains(unitRect) { return }
		
		let maxOffset = CGPoint(x: scrollView.contentSize.width - scrollView.bounds.width, y: scrollView.contentSize.height - scrollView.bounds.height)
		var newOffsetX = min(maxOffset.x, unitRect.midX * scrollView.contentSize.width - scrollView.bounds.width / 2)
		var newOffsetY = min(maxOffset.y, unitRect.midY * scrollView.contentSize.height - scrollView.bounds.height / 2)
		
		if newOffsetX < 0 { newOffsetX = 0 }
		if newOffsetY < 0 { newOffsetY = 0 }
		let newOffset = CGPoint(x: newOffsetX, y: newOffsetY)
		
		self.scrollView.contentOffset = newOffset
	}
}
