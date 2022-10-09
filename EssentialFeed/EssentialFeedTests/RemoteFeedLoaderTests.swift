//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Intan Nurjanah on 09/10/22.
//

import XCTest
// a better aproach (is to not use @testable), when possible, is to test the module through
// the public interfaces, so we can test the expected behavior as a client of the module
// benefit: we're free to change internal and private implementation details without breaking the tests.
import EssentialFeed

final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        // arrange: given a client and sut
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        // act: when we invoke sut.load()
        sut.load()
        
        // assert: then assert that a URL request was initiated in the client
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        // arrange: given the sut and its HTTP client spy
        let (sut, client) = makeSUT()
        
        // act: when we tell sut to load and we complete the client's HTTP request with an error
        // spy -> capturing the value
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }
        
        let clientError = NSError(domain: "Test", code: 0) // stub the client
        client.completions[0](clientError)
        
        // assert: then we expect the captured load error to be a connectivity error
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut: sut, client: client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        var completions = [(Error) -> Void]()
        
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            completions.append(completion)
            requestedURLs.append(url)
        }
    }
    
}
