//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 10/10/22.
//

import Foundation

// the `internal` is the default (no need to explicitly hardcoded it)
public final class FeedItemsMapper {
    // move the Root and Item structs here so no one as access to it
    private struct Root: Decodable {
        private let items: [RemoteFeedItem]
        
        // buat FeedItem model terpisah khusus untuk DAO dan decouple antara FeedItemsMapper dan FeedItem
        private struct RemoteFeedItem: Decodable {
            let id: UUID
            let description: String?
            let location: String?
            let image: URL // namanya sama dengan yang ada di response
        }
        
        var images: [FeedImage] {
            items.map {
                FeedImage(
                    id: $0.id,
                    description: $0.description,
                    location: $0.location,
                    url: $0.image
                )
            }
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [FeedImage] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        
        return root.images
    }
}
