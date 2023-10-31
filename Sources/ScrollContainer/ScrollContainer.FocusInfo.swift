//
//  ScrollContainer.FocusInfo.swift
//  ScrollContainer
//
//  Created by Ben Gottlieb on 10/31/23.
//

import Foundation
import Suite

extension ScrollContainer {
	public struct FocusInfo: Equatable, Hashable, CustomStringConvertible {
		public enum Bias: String, Hashable { case focus, highlight }
		let center: UnitRect?
		let visible: UnitRect?
		let bias: Bias
		
		public init(center: UnitRect? = nil, visible: UnitRect? = nil, bias: Bias = .focus) {
			self.bias = bias
			self.center = center
			self.visible = visible
		}
		
		public var description: String {
"""
	Bias: \(bias.rawValue)
	Center: \(center?.description ?? "--")
	Visible: \(visible?.description ?? "--")
"""
		}
	}
}
