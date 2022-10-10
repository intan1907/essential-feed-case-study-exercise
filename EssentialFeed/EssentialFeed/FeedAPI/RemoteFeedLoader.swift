//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 09/10/22.
//

import Foundation

public final class RemoteFeedLoader { // prevent subclasses
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            // bisa saja ada case di mana `client` hidup lebih lama dari `RemoteFeedLoader`
            // tetapi client menyimpan instance dari `load(completion:)` dan meng-invoke-nya
            // sedangkan kita tidak menginginkan behavior tsb
            // sehingga kita meng-capture `self` dengan `weak self`
            // lalu set guard untuk melanjutkan hanya jika `self` masih hidup
            guard self != nil else { return }
            
            switch result {
            case .success(let data, let response):
                completion(FeedItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
