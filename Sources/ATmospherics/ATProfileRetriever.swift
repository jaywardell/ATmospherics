//
//  File.swift
//  ATmospherics
//
//  Created by Joseph Wardell on 12/30/24.
//

import Foundation

public struct ATProfileRetriever {
        
    let atmosphere: Atmosphere

    // to retrieve a user profile, ATProto doesn't require credentials,
    // so it usually make sense to use the uncredentialed Atomosphere
    // for this simple purpose
    // unless there's a specific reason not to
    public init(atmosphere: Atmosphere = .uncredentialed) {
        self.atmosphere = atmosphere
    }
    
    public struct Profile: Sendable {
        public let handle: String
        public let displayName: String?
        public let description: String?
        public let avatarURL: URL?
        public let bannerURL: URL?
    }

    public func retrieveProfile(for authorHandle: String) async throws -> Profile {
        do {
            let profile = try await atmosphere.atProto().getProfile(for: authorHandle)

            return Profile(
                handle: profile.actorHandle,
                displayName: profile.displayName, description: profile.description,
                avatarURL: profile.avatarImageURL,
                bannerURL: profile.bannerImageURL
            )
        }
        catch {
            print()
            print("Error retrieveing profile for \(authorHandle)")
            print(error)
            print()
            
            throw error
        }
    }
}
    
