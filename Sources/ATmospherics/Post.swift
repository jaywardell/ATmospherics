//
//  Post.swift
//  ATmospherics
//
//  Created by Joseph Wardell on 3/11/25.
//

import Foundation

public struct Post {
    /// The URI of the post.
    public let uri: String
    
    /// The CID hash of the post.
    public let cid: String
    
    /// The text contained in the post.
    ///
    /// - Note: According to the AT Protocol specifications: "The primary post content. May be
    /// an empty string, if there are embeds."
    ///
    /// - Important: Current maximum length is 300 characters. This library will automatically
    /// truncate the `String` to the maximum length if it does go over the limit.
    public let text: String

    public let links: [URL]
    
    /// The date the post was created.
    ///
    /// - Note: According to the AT Protocol specifications: "Client-declared timestamp when this
    /// post was originally created."
    public let date: Date

    /// The number of replies in the post. Optional.
    public let replyCount: Int?

    /// The number of reposts in the post. Optional.
    public let repostCount: Int?

    /// The number of likes in the post. Optional.
    public let likeCount: Int?

    /// The number of quote posts in the post. Optional.
    public let quoteCount: Int?
}
