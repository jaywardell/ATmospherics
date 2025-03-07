//
//  File.swift
//  ATmospherics
//
//  Created by Joseph Wardell on 2/15/25.
//

public struct ProfileRetriever: Sendable {
    let handle: String
    
    public init(handle: String) {
        self.handle = handle
    }
    
    public func retrieveProfile(using atmosphere: Atmosphere = .uncredentialed) async throws -> Profile {
        
        let kit = try await atmosphere.atProto()
        let profile = try await kit.getProfile(for: handle)

        return Profile(
            handle: profile.actorHandle,
            displayName: profile.displayName, description: profile.description,
            avatarURL: profile.avatarImageURL,
            bannerURL: profile.bannerImageURL
        )
    }
}
