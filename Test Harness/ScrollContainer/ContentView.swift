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
	@State private var index: Int?
	
    var body: some View {
		 ScrollContainerReader { proxy in
			 ZStack {
				 ScrollContainer(contentSize: .init(width: 1024, height: 1024), focused: highlightedRect, visible: nil) {
					 GridView(selectedIndex: $index, highlightedUnitRect: $highlightedRect)
				 }
				 
				 VStack {
					 Text("\(proxy.visibleUnitRect.description)")
					 if let highlightedRect {
						 Text(highlightedRect.description)
					 }
					 
					 HStack {
						 Button(action: { index = (index ?? 0) - 1 }) {
							 Text("Prev")
						 }
						 .buttonStyle(.bordered)

						 Button(action: { index = (index ?? -1) + 1 }) {
							 Text("Next")
						 }
						 .buttonStyle(.bordered)
					 }
				 }
					 .padding()
					 .background(Color.systemBackground)
					 .opacity(0.7)
			 }
			 .font(.caption)
		 }
    }
}

#Preview {
    ContentView()
}
