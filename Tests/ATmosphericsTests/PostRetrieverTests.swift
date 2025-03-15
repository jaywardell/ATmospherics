//
//  Test.swift
//  ATmospherics
//
//  Created by Joseph Wardell on 3/11/25.
//

import Testing
import Foundation
import ATProtoKit
@testable import ATmospherics

@Suite("Retrieve post for AT URI")
struct retrievePostATURI {

    private let examplePostURI = ATURI("at://did:plc:o7axnjyztfjoowvmlyyekpwb/app.bsky.feed.post/3ljujgen6322k")!

    @Test("Throws if given uncredentialed atmopsphere")
    func throws_if_not_credentialed() async throws {
        let sut = PostRetriever()
        
        await #expect(throws: ATRequestPrepareError.missingActiveSession) {
            _ = try await sut.retrievePost(at: examplePostURI, using: .uncredentialed)
        }
    }
    
    @Test("Retrieves Post given URI")
    func retrieve_posts() async throws {
        let atmosphere = Atmosphere(credential: .testingAccount)

        let sut = PostRetriever()
        do {
            let post = try await sut.retrievePost(at: examplePostURI, using: atmosphere)
            #expect(nil != post)
            #expect(post?.uri == examplePostURI.at)
        }
        catch {
            print(error.localizedDescription)
            print(error)
            Issue.record("failed with error \(error)")
        }
    }

}

@Suite("Retrieve post for AT URI")
struct retrievePostURL {
    
    private let knownPrivatePost = URL(string: "https://bsky.app/profile/tee-tee.bsky.social/post/3lkfmpa6mwc2t")!
    
    @Test("Throws if given uncredentialed atmopsphere")
    func throws_if_not_credentialed() async throws {
        let sut = PostRetriever()
        
        await #expect(throws: ATRequestPrepareError.missingActiveSession) {
            _ = try await sut.retrievePost(for: knownPrivatePost, using: .uncredentialed)
        }
    }

    @Test("Retrieves Post given URL")
    func retrieve_posts() async throws {
        let atmosphere = Atmosphere(credential: .testingAccount)

        let sut = PostRetriever()
        do {
            let post = try await sut.retrievePost(for: knownPrivatePost, using: atmosphere)
            #expect(nil != post)
            #expect(post?.uri.components(separatedBy: "/").last == knownPrivatePost.lastPathComponent)
        }
        catch {
            print(error.localizedDescription)
            print(error)
            Issue.record("failed with error \(error)")
        }
    }

}
