//
//  File.swift
//  ATmospherics
//
//  Created by Joseph Wardell on 12/30/24.
//

import Foundation

public struct ATAvatarRetriever {
    
    let atmosphere: Atmosphere

    let profileRetriever: ATProfileRetriever
    
    // to retrieve a user profile, ATProto doesn't require credentials,
    // so it usually make sense to use the uncredentialed Atomosphere
    // for this simple purpose
    // unless there's a specific reason not to
    public init(atmosphere: Atmosphere = .uncredentialed) {
        self.atmosphere = atmosphere
        self.profileRetriever = ATProfileRetriever(atmosphere: atmosphere)
    }
    
    public func retrieveAvatarURL(for authorHandle: String) async throws -> URL? {
        try await profileRetriever.retrieveProfile(for: authorHandle).avatarURL
    }
}
