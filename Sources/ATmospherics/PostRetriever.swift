//
//  File.swift
//  ATmospherics
//
//  Created by Joseph Wardell on 3/11/25.
//

import Foundation
internal import ATProtoKit

public struct PostRetriever: Sendable {
        
    enum Error: Swift.Error {
        case AuthorNotAvailable
    }
    
    public func retrievePost(at uri: ATURI, using atmosphere: Atmosphere) async throws -> Post? {
        
        let kit = try await atmosphere.atProto()
        guard let post = try await kit.getPosts([uri.at]).posts.first else {
            return nil
        }
        
        return try post.getPost()
    }
    
    public func retrievePost(for url: URL, using atmosphere: Atmosphere, limit: Int = 100) async throws -> Post? {
        
        guard let handle = url.blueSkyProfileHandle else {
            throw Error.AuthorNotAvailable
        }
        
        let profileRetriever = ProfileRetriever(handle: handle)
        let profile = try await profileRetriever.retrieveProfile(using: atmosphere)
        
        let kit = try await atmosphere.atProto()
        
        var cursor: String?
        
        repeat {
            let response = try await kit.getAuthorFeed(by: profile.did, limit: limit, cursor: cursor, postFilter: nil, shouldIncludePins: nil)
                        
            let postID = url.blueSkyPostID
            
            let found = response.feed.map(\.post).first { post in
                ATURI(post.uri)?.blueskyPostID == postID
            }
            
            if let found {
                return try found.getPost()
            }
            else {
                // empirically, it appears that
                // response.cursor is nil
                // if there are no more posts
                // for the API to return
                cursor = response.cursor
            }
        } while cursor != nil
        
        return nil
    }

}

fileprivate extension AppBskyLexicon.Feed.PostViewDefinition {
    
    enum PostError: Swift.Error {
        case NotAPostRecord
    }

    // NOTE: technically, much of what's in here isn't covered by unit tests
    func getPost() throws -> Post {
        
        guard let record = record.getRecord(ofType: AppBskyLexicon.Feed.PostRecord.self) else {
            throw PostError.NotAPostRecord
        }
        print(record)
        
        let links: [String] = record.facets?
            .flatMap { facet in facet.features }
            .compactMap {
                switch $0 {
                case .link(let link): return link
                default: return nil
                }
            }
            .map(\.uri)
        ?? []
        
        
        
        return Post(
            uri: uri,
            cid: cid,
            text: record.text,
            links: links.compactMap(URL.init(string:)),
            date: record.createdAt,
            replyCount: replyCount,
            repostCount: repostCount,
            likeCount: likeCount,
            quoteCount: quoteCount
        )

    }
}
