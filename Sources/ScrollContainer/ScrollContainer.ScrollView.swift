//
//  ScrollContainer.ScrollView.swift
//  ScrollContainer
//
//  Created by Ben Gottlieb on 10/29/23.
//

import SwiftUI
import Suite

#if os(iOS)
extension ScrollContainer {
	class ContainerScrollView: UIScrollView {
		var coordinator: ScrollContainer.Coordinator!
		
		func scaleToFit() {
			let newScale = min(bounds.width / contentSize.width, bounds.height / contentSize.height)
			minimumZoomScale = min(newScale, 1.0)
			zoomScale = newScale
		}
		
		init(coordinator: ScrollContainer.Coordinator!, frame: CGRect) {
			super.init(frame: frame)
			self.coordinator = coordinator
			self.frame = frame
			
			addAsObserver(of: UIApplication.keyboardWillShowNotification, selector: #selector(keyboardWillShow))
			addAsObserver(of: UIApplication.keyboardWillHideNotification, selector: #selector(keyboardWillHide))
		}
		
		@objc func keyboardWillShow(_ note: Notification) {
			if let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, let window {
				let myFrame = self.convert(frame, to: window)
				let overlay = myFrame.intersection(frame)
				contentInset = UIEdgeInsets(top: 0, left: 0, bottom: overlay.height, right: 0)
			}
		}
		
		@objc func keyboardWillHide(_ note: Notification) {
			contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		}

		required init?(coder: NSCoder) {
			fatalError("init(coder:) not supported for ScrollContainer")
		}
		
		func scaleToFill() {
			let newScale = max(bounds.width / contentSize.width, bounds.height / contentSize.height)
			minimumZoomScale = min(min(bounds.width / contentSize.width, bounds.height / contentSize.height), 1.0)
			zoomScale = newScale
		}
		
		override var frame: CGRect { didSet {
			coordinator?.updateContentMode()
		}}
		
		var visibleUnitRect: UnitRect {
			if contentSize.width <= bounds.width, contentSize.height <= bounds.height, contentOffset.x <= 0, contentOffset.y <= 0 { return .full }
			
			var origin = UnitPoint.zero
			var size = UnitSize.full
			
			if contentOffset.x > 0 {
				origin.x = contentOffset.x / contentSize.width
			}

			if contentOffset.y > 0 {
				origin.y = contentOffset.y / contentSize.height
			}
			
			if bounds.width < contentSize.width {
				size.width = bounds.width / contentSize.width
			}

			if bounds.height < contentSize.height {
				size.height = bounds.height / contentSize.height
			}

			return UnitRect(origin: origin, size: size)
		}
	}
}
#endif
