//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 10/10/22.
//

import Foundation

// the `internal` is the default (no need to explicitly hardcoded it)
internal final class FeedItemsMapper {
    // move the Root and Item structs here so no one as access to it
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    private static var OK_200: Int { return 200 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard
            response.statusCode == OK_200,
            let root = try? JSONDecoder().decode(Root.self, from: data)
        else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.items
    }
}
