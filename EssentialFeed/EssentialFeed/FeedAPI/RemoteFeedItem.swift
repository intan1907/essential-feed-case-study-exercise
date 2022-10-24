//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 17/10/22.
//

import Foundation

// buat FeedItem model terpisah khusus untuk DAO dan decouple antara FeedItemsMapper dan FeedItem
struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL // namanya sama dengan yang ada di response
}
