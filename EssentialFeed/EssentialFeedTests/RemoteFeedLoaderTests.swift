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
        sut.load { _ in }
        
        // assert: then assert that a URL request was initiated in the client
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
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
        client.complete(with: clientError)
        
        // assert: then we expect the captured load error to be a connectivity error
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }
        
        client.complete(withStatusCode: 400)
        
        XCTAssertEqual(capturedErrors, [.invalidData])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut: sut, client: client)
    }
    
    // the spy's job is to capture the messages (invocations) in a clear and comprehensive way.
    // for example, how many times the message was invoked, with what parameters and in which order
    private class HTTPClientSpy: HTTPClient {
        // message passing = invoking behavior
        // in this case, calling the method `get(from url:, completion:)` is the "message"
        var messages = [(url: URL, completion: (Error?, HTTPURLResponse?) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(error, nil)
        }
        
        func complete(withStatusCode code: Int, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )
            messages[index].completion(nil, response)
        }
    }
    
}
