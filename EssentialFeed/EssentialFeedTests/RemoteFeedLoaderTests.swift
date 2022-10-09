//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Intan Nurjanah on 09/10/22.
//

import XCTest

class RemoteFeedLoader {
    func load() {
        // step 2: move the test logic from the RemoteFeedLoader to HTTPClient
        HTTPClient.shared.get(from: URL(string: "https://a-url.com")!)
    }
}

class HTTPClient {
    // step 1: make the shared instance variable
    static var shared = HTTPClient()
    
    // step 5: remove HTTPClient private initializer since it's not a Singleton anymore
    init() { } // this line need to be deleted
    
    func get(from url: URL) { }
}

// step 3: move the test logic to a new subclass of the HTTPClient
class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    override func get(from url: URL) {
        requestedURL = url
    }
}

final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        // step 4: swap the HTTPClient shared instance with the spy subclass during tests
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_init_requestDataFromURL() {
        // arrange: given a client and sut
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let sut = RemoteFeedLoader()
        
        // act: when we invoke sut.load()
        sut.load()
        
        // assert: then assert that a URL request was initiated in the client
        XCTAssertNotNil(client.requestedURL)
    }
    
}
