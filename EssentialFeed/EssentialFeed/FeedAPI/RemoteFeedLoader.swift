//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 09/10/22.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader { // prevent subclasses
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = FeedLoader.Result
    
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
            guard let self = self else { return }
            
            switch result {
            case .success(let data, let response):
                completion(self.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedItemsMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteFeedItem {
    func toModels() -> [FeedImage] {
        return map {
            FeedImage(
                id: $0.id,
                description: $0.description,
                location: $0.location,
                url: $0.image
            )
        }
    }
}
