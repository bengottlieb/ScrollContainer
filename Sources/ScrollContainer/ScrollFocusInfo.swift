//
//  ScrollFocusInfo.swift
//  ScrollContainer
//
//  Created by Ben Gottlieb on 10/31/23.
//

import Foundation
import Suite

public struct ScrollFocusInfo: Equatable, Hashable, CustomStringConvertible {
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
