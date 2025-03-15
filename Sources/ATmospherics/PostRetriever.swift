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
        
        guard let record = post.record.getRecord(ofType: AppBskyLexicon.Feed.PostRecord.self) else {
            throw Error.NotAPostRecord
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
            uri: post.uri,
            cid: post.cid,
            text: record.text,
            links: links.compactMap(URL.init(string:)),
            date: record.createdAt,
            replyCount: post.replyCount,
            repostCount: post.repostCount,
            likeCount: post.likeCount,
            quoteCount: post.quoteCount
        )
//        return Profile(
//            handle: profile.actorHandle,
//            displayName: profile.displayName, description: profile.description,
//            avatarURL: profile.avatarImageURL,
//            bannerURL: profile.bannerImageURL
//        )
    }

}
