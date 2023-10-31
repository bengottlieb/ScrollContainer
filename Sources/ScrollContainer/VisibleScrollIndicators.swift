//
//  VisibleScrollIndicators.swift
//  
//
//  Created by Ben Gottlieb on 10/31/23.
//

import Foundation

public struct VisibleScrollIndicators: RawRepresentable, OptionSet {
	public let rawValue: Int
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public static let horizontal = VisibleScrollIndicators(rawValue: 1 << 0)
	public static let vertical = VisibleScrollIndicators(rawValue: 1 << 1)
	public static let all: VisibleScrollIndicators = [.horizontal, .vertical]
}

