//
//  ContentView.swift
//  ScrollContainer
//
//  Created by Ben Gottlieb on 10/29/23.
//

import SwiftUI
import Suite

struct ContentView: View {
	@State private var highlightedRect: UnitRect?
	@State private var centeredRect: UnitRect?
	@State private var index: Int?
	@State private var text = ""
	
    var body: some View {
		 ScrollContainerReader { proxy in
			 VStack {
                 ScrollContainer(contentSize: .init(width: 600, height: 600), focus: .init(center: centeredRect, visible: highlightedRect, bias: .focus)) {
					 ZStack {
						 GridView(selectedIndex: $index, centeredUnitRect: $centeredRect, highlightedUnitRect: $highlightedRect)
					 }
				 }
				 
				 VStack {
					 Text("\(proxy.visibleUnitRect.description)")
					 Text("\(proxy.contentOffset.description) x\(proxy.zoomScale.pretty(2))")
					 if let centeredRect {
						 Text(centeredRect.description)
					 }
					 
					 HStack {
						 Button(action: { index = max(0, (index ?? 0) - 10) }) {
							 Text("Prev - 10")
						 }

						 Button(action: { index = max(0, (index ?? 0) - 1) }) {
							 Text("Prev")
						 }

						 Button(action: { index = min(255, (index ?? -1) + 1) }) {
							 Text("Next")
						 }

						 Button(action: { index = min(255, (index ?? -1) + 10) }) {
							 Text("Next + 10")
						 }
					 }
					 .buttonStyle(.bordered)
				 }
					 .padding()
					 .background(Color.systemBackground)
					 .opacity(0.7)
			 }
			 .font(.body.bold())
		 }
    }
}

#Preview {
    ContentView()
}
