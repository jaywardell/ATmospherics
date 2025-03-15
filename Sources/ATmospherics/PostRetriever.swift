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
        case NotAPostRecord
    }
    
    public func retrievePost(at uri: ATURI, using atmosphere: Atmosphere) async throws -> Post? {
        
        let kit = try await atmosphere.atProto()
        guard let post = try await kit.getPosts([uri.at]).posts.first else {
            return nil
        }
        
        return try post.getPost()
    }
    
    public func retrievePost(for url: URL, using atmosphere: Atmosphere) async throws -> Post? {
        
        let kit = try await atmosphere.atProto()
        guard let post = try await kit.getPosts([url.absoluteString]).posts.first else {
            return nil
        }
        
        return try post.getPost()
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
