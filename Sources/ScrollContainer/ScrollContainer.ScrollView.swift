//
//  ScrollContainer.ScrollView.swift
//  ScrollContainer
//
//  Created by Ben Gottlieb on 10/29/23.
//

import SwiftUI
import Suite

extension ScrollContainer {
	class ContainerScrollView: UIScrollView {
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
