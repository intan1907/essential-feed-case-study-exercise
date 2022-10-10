//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 10/10/22.
//

import Foundation

// the `internal` is the default (no need to explicitly hardcoded)
internal final class FeedItemsMapper {
    // move the Root and Item structs here so no one as access to it
    private struct Root: Decodable {
        let items: [Item]
        
        var feed: [FeedItem] {
            return items.map { $0.item }
        }
    }

    // buat FeedItem model terpisah khusus untuk DAO
    private struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL // namanya sama dengan yang ada di response
        
        // mapper ke domain model
        var item: FeedItem {
            return FeedItem(
                id: id,
                description: description,
                location: location,
                imageURL: image
            )
        }
    }
    
    private static var OK_200: Int { return 200 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard
            response.statusCode == OK_200,
            let root = try? JSONDecoder().decode(Root.self, from: data)
        else {
            return .failure(.invalidData)
        }
        
        return .success(root.feed)
    }
}
