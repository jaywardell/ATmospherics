//
//  Profile.swift
//  ATmospherics
//
//  Created by Joseph Wardell on 2/15/25.
//

import Foundation

/// A Container type that holds the data that can be retrieved by ProfileRetriever
public struct Profile: Sendable {
    public let handle: String
    internal let did: String
    public let displayName: String?
    public let description: String?
    public let avatarURL: URL?
    public let bannerURL: URL?
}
