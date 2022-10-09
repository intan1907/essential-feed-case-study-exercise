//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Intan Nurjanah on 09/10/22.
//

import XCTest

class RemoteFeedLoader {
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load() {
        client.get(from: URL(string: "https://a-url.com")!)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    func get(from url: URL) {
        requestedURL = url
    }
}

final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_init_requestDataFromURL() {
        // arrange: given a client and sut
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client)
        
        // act: when we invoke sut.load()
        sut.load()
        
        // assert: then assert that a URL request was initiated in the client
        XCTAssertNotNil(client.requestedURL)
    }
    
}
