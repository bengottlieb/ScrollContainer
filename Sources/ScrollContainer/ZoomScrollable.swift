//
//  ZoomScrollable.swift
//  ScrollContainer
//
//  Created by Ben Gottlieb on 10/31/23.
//

import SwiftUI

public extension View {
	@ViewBuilder func zoomScrollable(contentSize: CGSize, maximimumScale: Double = 2.0, focus: ScrollFocusInfo = .init(), indicators: VisibleScrollIndicators = .all) -> some View {
		if #available(iOS 16.0, macOS 99, *) {
			ScrollContainer(contentSize: contentSize, maximimumScale: maximimumScale, focus: focus, indicators: indicators) { self }
		} else {
			self
		}
	}
}

