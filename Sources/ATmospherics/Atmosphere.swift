//
//  ATRetriever.swift
//  ATProtoKit Tests
//
//  Created by Joseph Wardell on 12/30/24.
//

import Foundation
internal import ATProtoKit

/// encapsulates the authentication process of ATProtoKit
public final class Atmosphere {
    
    public struct Credential {
        let handle: String
        let appPassword: String
    }
    let credential: Credential?
    private var cachedATProto: ATProtoKit?
    private var cachedATProtoBlueSky: ATProtoBluesky?

    public init(credential: Credential?) {
        self.credential = credential
    }
    
    public static var uncredentialed: Atmosphere { Atmosphere(credential: nil) }
    
    func atProto() async throws -> ATProtoKit {
        if let cachedATProto { return cachedATProto }
        
        let out: ATProtoKit
        if let credential {
            let config = ATProtocolConfiguration(handle: credential.handle, appPassword: credential.appPassword)
            try await config.authenticate()
            
            out = ATProtoKit(sessionConfiguration: config)
        }
        else {
            out = ATProtoKit()
        }
        
        cachedATProto = out
        return out
    }
    
    func atProtoBluesky() async throws -> ATProtoBluesky {
        if let cachedATProtoBlueSky { return cachedATProtoBlueSky }
        
        let out = ATProtoBluesky(atProtoKitInstance: try await atProto())
        cachedATProtoBlueSky = out
        return out
    }
}
    
extension Atmosphere {
    public func retrieveProfile(for authorHandle: String) async throws -> Profile {
        do {
            let profile = try await atProto().getProfile(for: authorHandle)
            
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

public struct ProfileRetriever: Sendable {
    let handle: String
    
    public init(handle: String) {
        self.handle = handle
    }
    
    public func retrieveProfile() async throws -> Profile {
        try await Atmosphere.uncredentialed.retrieveProfile(for: handle)
    }
}
