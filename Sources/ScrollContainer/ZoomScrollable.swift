//
//  ZoomScrollable.swift
//  ScrollContainer
//
//  Created by Ben Gottlieb on 10/31/23.
//

import SwiftUI

public extension View {
	@ViewBuilder func zoomScrollable(contentSize: CGSize, backgroundColor: Color = .black, scrollEnabled: Bool = true, delaysContentTouches: Bool = true, maximimumScale: Double = 2.0, focus: ScrollFocusInfo = .init(), indicators: VisibleScrollIndicators = .all, toFit: Bool = false) -> some View {
		#if os(iOS)
			if #available(iOS 16.0, *) {
				ScrollContainer(scrollEnabled: scrollEnabled, contentSize: contentSize, backgroundColor: backgroundColor, maximimumScale: maximimumScale, delaysContentTouches: delaysContentTouches, focus: focus, indicators: indicators, toFit: toFit) { self }
			} else {
				self
			}
		#else
			self
		#endif
	}
}

