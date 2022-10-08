//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Intan Nurjanah on 09/10/22.
//

import XCTest

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "https://a-url.com")
    }
}

class HTTPClient {
    static let shared = HTTPClient()
    
    private init() { }
    
    var requestedURL: URL?
}

final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient.shared
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_init_requestDataFromURL() {
        // arrange: given a client and sut
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        
        // act: when we invoke sut.load()
        sut.load()
        
        // assert: then assert that a URL request was initiated in the client
        XCTAssertNotNil(client.requestedURL)
    }
    
}
