//
//  RemoteLoader.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 16/12/22.
//

import Foundation

public final class RemoteLoader<Resource> { // prevent subclasses
    private let url: URL
    private let client: HTTPClient
    private let mapper: Mapper
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = Swift.Result<Resource, Swift.Error>
    public typealias Mapper = (Data, HTTPURLResponse) throws -> Resource
    
    public init(url: URL, client: HTTPClient, mapper: @escaping Mapper) {
        self.url = url
        self.client = client
        self.mapper = mapper
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
            case let .success((data, response)):
                completion(self.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            return .success(try mapper(data, response))
        } catch {
            return .failure(Error.invalidData)
        }
    }
}
