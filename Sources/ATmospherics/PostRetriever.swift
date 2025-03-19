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
    
    public init() {}
    
    public func retrievePost(at uri: ATURI, using atmosphere: Atmosphere) async throws -> PostInstance? {
        
        let kit = try await atmosphere.atProto()
        guard let post = try await kit.getPosts([uri.at]).posts.first else {
            return nil
        }
        
        return try post.getPost()
    }
    
    public func retrievePostInstance(for url: URL, using atmosphere: Atmosphere, batchSize limit: Int = 100) async throws -> PostInstance? {
        
        try await retrievePost(for: url, using: atmosphere, batchSize: limit)?.post
    }

    public func retrievePost(for url: URL, using atmosphere: Atmosphere, batchSize  limit: Int = 100) async throws -> Post? {
        
        guard let handle = url.blueSkyProfileHandle else {
            throw Error.AuthorNotAvailable
        }
        
        let profileRetriever = ProfileRetriever(handle: handle)
        let profile = try await profileRetriever.retrieveProfile(using: atmosphere)
        
        let kit = try await atmosphere.atProto()
        
        let postID = url.blueSkyPostID
        var cursor: String?
        repeat {
            let response = try await kit.getAuthorFeed(by: profile.did, limit: limit, cursor: cursor, postFilter: nil)
                                    
            let found = response.feed.map(\.post).first { post in
                ATURI(post.uri)?.blueskyPostID == postID
            }
            
            if let found {
                let post = try found.getPost()
                return Post(post: post, author: profile)
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
    func getPost() throws -> PostInstance {
        
        guard let record = record.getRecord(ofType: AppBskyLexicon.Feed.PostRecord.self) else {
            throw PostError.NotAPostRecord
        }
        
        
        // TODO: add mentions and tags to the Post in the same way as links
                
        return PostInstance(
            uri: uri,
            cid: cid,
            text: record.text,
            links: record.links,
            images: images,
            date: record.createdAt,
            replyCount: replyCount,
            repostCount: repostCount,
            likeCount: likeCount,
            quoteCount: quoteCount
        )
    }
    
    var images: [PostInstance.Image] {
        
        guard case .embedImagesView(let imageView) = embed else { return [] }

        return imageView.images.map(PostInstance.Image.init)
    }

}

fileprivate extension AppBskyLexicon.Feed.PostRecord {
    
    private var facetFeatures: [ATUnion.FacetFeatureUnion] {
        facets?.flatMap { facet in facet.features } ?? []
    }
    
    var links: [URL] {
        facetFeatures
            .compactMap {
                switch $0 {
                case .link(let link): return link
                default: return nil
                }
            }
            .map(\.uri)
            .compactMap(URL.init(string:))
    }
}

fileprivate extension PostInstance.Image {
    init(_ viewImage: AppBskyLexicon.Embed.ImagesDefinition.ViewImage) {
        self.altText = viewImage.altText
        self.fullSizeURL = viewImage.fullSizeImageURL
        self.thumbnailURL = viewImage.thumbnailImageURL
    }
}
