//
//  URL+BlueskyAdditions.swift
//  ATmospherics
//
//  Created by Joseph Wardell on 3/13/25.
//

import Foundation

extension URL {
    
    private var isHTTPURL: Bool {
        [
            "http",
            "https"
        ]
            .contains(scheme)
    }
    
    var blueSkyProfileHandle: String? {
        guard isHTTPURL,
              host == "bsky.app"
        else { return nil }
        
        return pathComponents.itemAfterFirstInstance(of: "profile")
    }
    
    // TODO: need tests for this
    var blueSkyPostID: String? {
        guard isHTTPURL,
              host == "bsky.app"
        else { return nil }
        
        return pathComponents.itemAfterFirstInstance(of: "post")
    }

}
