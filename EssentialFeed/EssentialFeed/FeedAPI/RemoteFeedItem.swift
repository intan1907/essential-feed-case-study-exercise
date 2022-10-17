//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 17/10/22.
//

import Foundation

// buat FeedItem model terpisah khusus untuk DAO dan decouple antara FeedItemsMapper dan FeedItem
internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL // namanya sama dengan yang ada di response
}
