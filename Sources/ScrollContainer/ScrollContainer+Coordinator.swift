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
		var focus: FocusInfo
		var scrollContainerProxyBinding: Binding<ScrollContainerProxy>
		var indicators: VisibleScrollIndicators
		
		init(contentSize: CGSize, maximumScale: Double, focus: FocusInfo, proxy: Binding<ScrollContainerProxy>, indicators: VisibleScrollIndicators, content: @escaping () -> Content) {
			self.content = content
			self.scrollContainerProxyBinding = proxy
			self.maximumScale = maximumScale
			self.focus = focus
			self.indicators = indicators
			super.init()

			controller = UIHostingController(rootView: FixedSize(size: contentSize.scaled(by: maximumScale), content: content))
			
			scrollView = ContainerScrollView()
			scrollView.showsHorizontalScrollIndicator = indicators.contains(.horizontal)
			scrollView.showsVerticalScrollIndicator = indicators.contains(.vertical)
			scrollView.backgroundColor = .gray
			scrollView.delegate = self
			controller.view.frame = CGRect(origin: .zero, size: contentSize)
			scrollView.addSubview(controller.view)
			scrollView.contentSize = contentSize
//			scrollView.zoomScale = 1 / maximumScale
//			scrollView.minimumZoomScale = 1 / maximumScale
			scrollView.maximumZoomScale = maximumScale
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
			}
		}
	}
}

extension ScrollContainer.Coordinator {
	func scrollTo(focus: ScrollContainer.FocusInfo, animationDuration: TimeInterval = 0.2) {
		if let center = focus.center, center != self.focus.center {
			self.focus = focus
			if !scrollView.visibleUnitRect.contains(center) {
				let maxOffset = CGPoint(x: scrollView.contentSize.width - scrollView.bounds.width, y: scrollView.contentSize.height - scrollView.bounds.height)
				var newOffsetX = min(maxOffset.x, center.midX * scrollView.contentSize.width - scrollView.bounds.width / 2)
				var newOffsetY = min(maxOffset.y, center.midY * scrollView.contentSize.height - scrollView.bounds.height / 2)
				
				if newOffsetX < 0 { newOffsetX = 0 }
				if newOffsetY < 0 { newOffsetY = 0 }
				let newOffset = CGPoint(x: newOffsetX, y: newOffsetY)
				
				UIView.animate(withDuration: animationDuration) {
					self.scrollView.contentOffset = newOffset
				}
//				scrollView.setContentOffset(newOffset, animated: false)
			}
		}
	}
}
