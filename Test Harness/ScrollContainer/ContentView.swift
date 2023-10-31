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
				 ScrollContainer(contentSize: .init(width: 1024, height: 1024), focus: .init(center: highlightedRect)) {
					 GridView(selectedIndex: $index, highlightedUnitRect: $highlightedRect)
				 }
				 
				 VStack {
					 Text("\(proxy.visibleUnitRect.description)")
					 Text("\(proxy.contentOffset.description)")
					 if let highlightedRect {
						 Text(highlightedRect.description)
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
