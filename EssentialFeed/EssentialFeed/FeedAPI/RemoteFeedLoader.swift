//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 09/10/22.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error) -> Void)
}

public final class RemoteFeedLoader { // prevent subclasses
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Error) -> Void = { _ in }) {
        client.get(from: url) { error in
            completion(.connectivity)
        }
    }
}
