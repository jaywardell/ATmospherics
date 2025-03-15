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
    
    var pathSeparator: String.Element { "/" }
    
    var path: String {
        guard let startIndex = at.firstIndex(of: pathSeparator)
        else { return "" }
        let suffix = at.suffix(from: startIndex)
        return String(suffix)
    }
    
    var pathComponents: [String] {
        path.components(separatedBy: String(pathSeparator))
    }
    
    var blueskyPostID: String? {
        pathComponents.itemAfterFirstInstance(of: "app.bsky.feed.post")
    }
}
