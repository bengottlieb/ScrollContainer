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
		var visibleRect: UnitRect?
		var focusedRect: UnitRect?
		var scrollContainerProxyBinding: Binding<ScrollContainerProxy>
		
		init(contentSize: CGSize, maximumScale: Double, focused: UnitRect?, visible: UnitRect?, proxy: Binding<ScrollContainerProxy>, content: @escaping () -> Content) {
			self.content = content
			self.scrollContainerProxyBinding = proxy
			self.maximumScale = maximumScale
			self.focusedRect = focused
			self.visibleRect = visible
			super.init()

			controller = UIHostingController(rootView: FixedSize(size: contentSize, content: content))
			
			scrollView = ContainerScrollView()
			scrollView.backgroundColor = .gray
			scrollView.delegate = self
			controller.view.frame = CGRect(origin: .zero, size: contentSize)
			scrollView.addSubview(controller.view)
			scrollView.contentSize = contentSize
			scrollView.minimumZoomScale = 0.5
			scrollView.maximumZoomScale = 2
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
				self.scrollContainerProxyBinding.wrappedValue.visibleUnitRect = self.scrollView.visibleUnitRect
			}
		}
	}
}

extension ScrollContainer.Coordinator {
	func scrollTo(visible: UnitRect?, focused: UnitRect?, animationDuration: TimeInterval = 0.2) {
		if let focused, focused != focusedRect {
			focusedRect = focused
			if !scrollView.visibleUnitRect.contains(focused) {
				let maxOffset = CGPoint(x: scrollView.contentSize.width - scrollView.bounds.width, y: scrollView.contentSize.height - scrollView.bounds.height)
				var newOffsetX = min(maxOffset.x, focused.midX * scrollView.contentSize.width - scrollView.bounds.width / 2)
				var newOffsetY = min(maxOffset.y, focused.midY * scrollView.contentSize.height - scrollView.bounds.height / 2)
				
				if newOffsetX < 0 { newOffsetX = 0 }
				if newOffsetY < 0 { newOffsetY = 0 }
				let newOffset = CGPoint(x: newOffsetX, y: newOffsetY)
				
//				UIView.animate(withDuration: animationDuration) {
					self.scrollView.contentOffset = newOffset
//				}
//				scrollView.setContentOffset(newOffset, animated: false)
			}
		}
	}
}
