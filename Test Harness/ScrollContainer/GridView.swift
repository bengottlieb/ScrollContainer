//
//  GridView.swift
//  ScrollContainer
//
//  Created by Ben Gottlieb on 10/29/23.
//

import SwiftUI
import Suite

struct GridView: View {
	var width = 15
	var height = 15
	
	let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
	
	@Binding var selectedIndex: Int?
	@Binding var highlightedUnitRect: UnitRect?
	
	@State private var highlightedX: Int?
	@State private var highlightedY: Int?
	@State private var highlightedAcross = true

	var body: some View {
		VStack(spacing: 0) {
			ForEach(0..<height, id: \.self) { y in
				HStack(spacing: 0) {
					ForEach(0..<width, id: \.self) { x in
						let index = x + y * width
						Text("\(index + 1)")
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.background { color(for: x, y: y) }
							.border(Color.gray, width: 0.5)
							.minimumScaleFactor(0.5)
							.gesture(TapGesture().onEnded {
								if highlightedX == x, highlightedY == y {
									highlightedAcross.toggle()
								} else {
									highlightedX = x
									highlightedY = y
								}
								updateSelection()
							})
					}
				}
			}
		}
		.aspectRatio(1, contentMode: .fit)
		.onChange(of: selectedIndex) {
			if let selectedIndex {
				if selectedIndex < 0 {
					self.selectedIndex = width * height - 1
					highlightedX = width - 1
					highlightedY = height - 1
				} else {
					highlightedX = selectedIndex % width
					highlightedY = selectedIndex / width
				}
			}
			updateSelection()
		}
	}
	
	func updateSelection() {
		guard let x = highlightedX, let y = highlightedY else { return }
		
		selectedIndex = y * width + x
		let xDim = CGFloat(1 / Double(width))
		let yDim = CGFloat(1 / Double(height))
		highlightedUnitRect = .init(origin: .init(x: xDim * Double(x), y: yDim * Double(y)), size: .init(width: xDim, height: yDim))
	}
	func color(for x: Int, y: Int) -> Color {
		if x == highlightedX, y == highlightedY { return .red }
		
		if highlightedAcross, y == highlightedY { return .yellow }
		if !highlightedAcross, x == highlightedX { return .yellow }
		return .white
	}
}

#Preview {
	GridView(selectedIndex: .constant(nil), highlightedUnitRect: .constant(nil))
}
