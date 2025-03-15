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

struct Test {

    let examplePostURI = "at://did:plc:o7axnjyztfjoowvmlyyekpwb/app.bsky.feed.post/3ljujgen6322k"

    @Test("Throws if given uncredentialed ")
    func throws_if_not_credentialed() async throws {
        let sut = PostRetriever()
        do {
            _ = try await sut.retrievePost(at: examplePostURI, using: .uncredentialed)
        }
        catch {
            let error = try #require(error as? ATRequestPrepareError)
            switch error {
                
            case .missingActiveSession: break
                
                // any other error is not expected
                default: Issue.record("received an unexpected error \(error)")
            }
        }
    }
    
    @Test("Retrieves Post given URI")
    func retrieve_posts() async throws {
        let atmosphere = Atmosphere(credential: .testingAccount)

        let sut = PostRetriever()
        do {
            let post = try await sut.retrievePost(at: examplePostURI, using: atmosphere)
            #expect(nil != post)
            #expect(post?.uri == examplePostURI)
        }
        catch {
            print(error.localizedDescription)
            print(error)
            Issue.record("failed with error \(error)")
        }
    }

}
