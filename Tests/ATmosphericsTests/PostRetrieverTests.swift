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

@Suite("Retrieve post instance for URL")
struct retrievePostInstanceForURL {
    
    // This post is private becuase
    //
    // Logged-out visibility
    // Discourage apps from showing my account to logged-out users
    //
    // has been turned on for its account
    private let knownPrivatePost = URL(string: "https://bsky.app/profile/atmosphericstests.bsky.social/post/3lknpurb4nc23")!
    
    // This post has limited interactivity
    // it's marked as only being replyable by followers
    // but it should still be viewable
    // since only interactions are blocked, not viewing
    private let knownLimitedInteractivePost = URL(string: "https://bsky.app/profile/skymarks.bsky.social/post/3lknsaddvqc2h")!
    
    @Test("Throws if given uncredentialed atmopsphere")
    func throws_if_not_credentialed() async throws {
        let sut = PostRetriever()
        
        await #expect(throws: ATRequestPrepareError.missingActiveSession) {
            _ = try await sut.retrievePostInstance(for: knownPrivatePost, using: .uncredentialed)
        }
    }

    @Test("Retrieves Post Instance given URL")
    func retrieve_posts() async throws {
        let atmosphere = Atmosphere(credential: .testingAccount)

        let sut = PostRetriever()

        // intentionally set a batch size of 1
        // so that multiple requests have to be made
        let post = try await sut.retrievePostInstance(for: knownPrivatePost, using: atmosphere, batchSize: 1)
        #expect(nil != post)
        #expect(post?.uri.components(separatedBy: "/").last == knownPrivatePost.lastPathComponent)
        #expect(post?.text == "This post should appear as private and not show up for users who are not logged in")
    }

    @Test("Retrieves Post Instance given URL for post with limited interaction")
    func retrieve_post_limited_interaction() async throws {
        let atmosphere = Atmosphere(credential: .testingAccount)

        let sut = PostRetriever()
        let post = try await sut.retrievePostInstance(for: knownLimitedInteractivePost, using: atmosphere)
        #expect(nil != post)
        #expect(post?.uri.components(separatedBy: "/").last == knownLimitedInteractivePost.lastPathComponent)
        #expect(post?.text == "Coming soon hopefully, the ability to bookmark a private post (assuming that your account can view it)")
    }
}

@Suite("Retrieve post for URL")
struct retrievePostForURL {
    
    // This post is private becuase
    //
    // Logged-out visibility
    // Discourage apps from showing my account to logged-out users
    //
    // has been turned on for its account
    private let knownPrivatePost = URL(string: "https://bsky.app/profile/atmosphericstests.bsky.social/post/3lknpurb4nc23")!
    
    // This post has limited interactivity
    // it's marked as only being replyable by followers
    // but it should still be viewable
    // since only interactions are blocked, not viewing
    private let knownLimitedInteractivePost = URL(string: "https://bsky.app/profile/skymarks.bsky.social/post/3lknsaddvqc2h")!
    
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

        let post = try await sut.retrievePost(for: knownPrivatePost, using: atmosphere)
        #expect(nil != post)
        #expect(post?.post.uri.components(separatedBy: "/").last == knownPrivatePost.lastPathComponent)
        #expect(post?.post.text == "This post should appear as private and not show up for users who are not logged in")
        #expect(post?.author.handle == "atmosphericstests.bsky.social")
    }

    @Test("Retrieves Post given URL for post with limited interaction")
    func retrieve_post_limited_interaction() async throws {
        let atmosphere = Atmosphere(credential: .testingAccount)

        let sut = PostRetriever()
        let post = try await sut.retrievePost(for: knownLimitedInteractivePost, using: atmosphere)
        #expect(nil != post)
        #expect(post?.post.uri.components(separatedBy: "/").last == knownLimitedInteractivePost.lastPathComponent)
        #expect(post?.post.text == "Coming soon hopefully, the ability to bookmark a private post (assuming that your account can view it)")
        #expect(post?.author.handle == "skymarks.bsky.social")
        #expect(post?.post.images.isEmpty == true)
    }
    
    let knownPostWithImages = URL(string: "https://bsky.app/profile/atmosphericstests.bsky.social/post/3lkpaglh7422h")!
    @Test("Retrieves Embedded Post Images given URL for post")
    func retrieve_post_images() async throws {
        let atmosphere = Atmosphere(credential: .testingAccount)

        let sut = PostRetriever()
        let postOptional = try await sut.retrievePost(for: knownPostWithImages, using: atmosphere)
        
        // ensure we got the right one
        let post = try #require(postOptional)
        try #require(post.post.uri.components(separatedBy: "/").last == knownPostWithImages.lastPathComponent)
        try #require(post.post.text == "Here's a post with some images")
        
        let expectedImageURLs = [
            "https://cdn.bsky.app/img/feed_fullsize/plain/did:plc:zxnuajvzo3pycufhlh5ufrhr/bafkreibduizer4hzgs5myczhucoy2qnfm2j2szni77hmenq2qyvg4cfnay@jpeg", 
            "https://cdn.bsky.app/img/feed_fullsize/plain/did:plc:zxnuajvzo3pycufhlh5ufrhr/bafkreicwtff2wlul7jfcw5kikln6yoab3vfwjz3h3st5v3nwm22x4v7umy@jpeg",
            "https://cdn.bsky.app/img/feed_fullsize/plain/did:plc:zxnuajvzo3pycufhlh5ufrhr/bafkreigdvpzug2pye2qatpuzdtlx4dvmwo7r7uklxdc2yw36qqnncvuzeu@jpeg"
        ]
            .map(URL.init(string:))
        
        #expect(post.post.imageURLs.isEmpty == false)
        #expect(post.post.imageURLs == expectedImageURLs)
//        Issue.record(Comment(stringLiteral: post.post.imageURLs.map(\.absoluteString).joined(separator: ", ")))
    }

}
