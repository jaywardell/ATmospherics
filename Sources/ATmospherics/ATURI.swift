//
//  File.swift
//  ATmospherics
//
//  Created by Joseph Wardell on 3/15/25.
//

import Foundation

public struct ATURI: Sendable {
    
    let at: String
    
    public init?(_ string: String) {
        guard string.hasPrefix("at:") else { return nil }
        self.at = string
    }
}
