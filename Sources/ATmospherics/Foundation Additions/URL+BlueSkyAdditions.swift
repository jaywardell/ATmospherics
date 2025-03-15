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
              host == "bsky.app",
              let profileIndex =
                pathComponents.firstIndex(of: "profile"),
                pathComponents.count > profileIndex + 1
        else { return nil }
        
        return pathComponents[profileIndex+1]
    }
    
    // TODO: need tests for this
    var blueSkyPostID: String? {
        guard isHTTPURL,
              host == "bsky.app",
              let profileIndex =
                pathComponents.firstIndex(of: "post"),
                pathComponents.count > profileIndex + 1
        else { return nil }
        
        return pathComponents[profileIndex+1]
    }

}
