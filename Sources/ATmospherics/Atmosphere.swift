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
    
    public struct Credential: Sendable {
        let handle: String
        let appPassword: String
    }
    let credential: Credential?
    private var cachedATProto: ATProtoKit?
    private var cachedATProtoBlueSky: ATProtoBluesky?

    public init(credential: Credential?) {
        self.credential = credential
    }
    
    // unsafe is not a big deal here because
    nonisolated(unsafe) public static let uncredentialed = Atmosphere(credential: nil)
    
    func atProto() async throws -> ATProtoKit {
        if let cachedATProto { return cachedATProto }
        
        let out: ATProtoKit
        if let credential {
            let config = ATProtocolConfiguration(handle: credential.handle, appPassword: credential.appPassword)
            try await config.authenticate()
            
            out = await ATProtoKit(sessionConfiguration: config)
        }
        else {
            out = await ATProtoKit()
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
