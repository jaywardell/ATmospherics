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

@Suite("Retrieve post for URL")
struct retrievePostURL {
    
    // This post is private becuase
    //
    // Logged-out visibility
    // Discourage apps from showing my account to logged-out users
    //
    // has been turned on for its account
    private let knownPrivatePost = URL(string: "https://bsky.app/profile/atmosphericstests.bsky.social/post/3lknpurb4nc23")!
    
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
            #expect(post?.text == "This post should appear as private and not show up for users who are not logged in")
        }
        catch {
            print(error.localizedDescription)
            print(error)
            Issue.record("failed with error \(error)")
        }
    }

}
