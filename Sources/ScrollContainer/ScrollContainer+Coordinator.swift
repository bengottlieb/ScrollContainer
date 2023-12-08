//
//  ScrollContainer+Coordinator.swift
//  ScrollContainer
//
//  Created by Ben Gottlieb on 10/29/23.
//

import SwiftUI
import Suite

#if os(iOS)
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
		var delaysContentTouches = true
        var scrollEnabled = true { didSet { scrollView.isScrollEnabled = scrollEnabled }}
		
        init(scrollEnabled: Bool, contentSize: CGSize, maximumScale: Double, delaysContentTouches: Bool, focus: ScrollFocusInfo, proxy: Binding<ScrollContainerProxy>, indicators: VisibleScrollIndicators, content: @escaping () -> Content) {
			self.content = content
			self.scrollContainerProxyBinding = proxy
			self.maximumScale = maximumScale
			self.focus = focus
			self.indicators = indicators
            self.scrollEnabled = scrollEnabled
			self.delaysContentTouches = delaysContentTouches
			super.init()

			controller = UIHostingController(rootView: FixedSize(size: contentSize, content: content))
			
			scrollView = ContainerScrollView()
			scrollView.coordinator = self
			scrollView.showsHorizontalScrollIndicator = indicators.contains(.horizontal)
			scrollView.showsVerticalScrollIndicator = indicators.contains(.vertical)
			scrollView.backgroundColor = .gray
			scrollView.keyboardDismissMode = .none
			scrollView.delegate = self
            scrollView.isScrollEnabled = scrollEnabled
			controller.view.frame = CGRect(origin: .zero, size: contentSize)
			scrollView.delaysContentTouches = delaysContentTouches
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
	func scrollTo(focus newFocus: ScrollFocusInfo, animationDuration: TimeInterval = 0.2) {
		if newFocus == focus { return }
		if let center = newFocus.center, scrollView.visibleUnitRect.contains(center), (newFocus.bias == .focus || newFocus.visible == nil) { return }

		UIView.animate(withDuration: animationDuration) { [unowned self] in

			if let visible = newFocus.visible {
				refocus(on: visible, resize: false)
			}

			if let center = newFocus.center, center != focus.center {
				refocus(on: center, resize: false)
			}

			focus = newFocus
		}
	}

	func refocus(on unitRect: UnitRect, resize: Bool = false) {
		if scrollView.visibleUnitRect.contains(unitRect) { return }
		
		var newOffset = scrollView.contentOffset
		let visible = scrollView.visibleUnitRect//.inset(width: 0.1, height: 0.1)
		
		let maxOffset = CGPoint(x: scrollView.contentSize.width * 1 - scrollView.bounds.width, y: scrollView.contentSize.height * 1 - scrollView.bounds.height)
		var newOffsetX = min(maxOffset.x, unitRect.midX * scrollView.contentSize.width - scrollView.bounds.width / 2)
		var newOffsetY = min(maxOffset.y, unitRect.midY * scrollView.contentSize.height - scrollView.bounds.height / 2)
		
		if newOffsetX < 0 { newOffsetX = 0 }
		if newOffsetY < 0 { newOffsetY = 0 }
		
		if visible.verticalOverlap(with: unitRect).height < unitRect.height {
			newOffset.y = newOffsetY
		}

		if visible.horizontalOverlap(with: unitRect).width < unitRect.width {
			newOffset.x = newOffsetX
		}
		
		self.scrollView.contentOffset = newOffset
	}
}

extension UnitRect {
	func inset(width deltaWidth: CGFloat, height deltaHeight: CGFloat) -> UnitRect {
		UnitRect(origin: UnitPoint(x: x + deltaWidth, y: y + deltaHeight), size: UnitSize(width: width - 2 * deltaWidth, height: height - 2 * deltaHeight))
	}

	func horizontalOverlap(with rect: UnitRect) -> UnitSize {
		var copy = rect
		copy.origin.y = y
		copy.size.height = height
		
		return copy.overlap(with: self)?.size ?? .zero
	}
	
	func verticalOverlap(with rect: UnitRect) -> UnitSize {
		var copy = rect
		copy.origin.x = x
		copy.size.width = width
		
		return copy.overlap(with: self)?.size ?? .zero
	}
}
#endif
