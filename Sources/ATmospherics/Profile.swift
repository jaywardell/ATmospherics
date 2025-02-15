//
//  Profile.swift
//  ATmospherics
//
//  Created by Joseph Wardell on 2/15/25.
//

import Foundation

public struct Profile: Sendable {
    public let handle: String
    public let displayName: String?
    public let description: String?
    public let avatarURL: URL?
    public let bannerURL: URL?
}
