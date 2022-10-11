//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Intan Nurjanah on 11/10/22.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_failsOnRequestError() {
        // register the stub
        URLProtocolStub.startInterceptingRequests()
        let url = URL(string: "http://any-url.com")!
        let expectedError = NSError(domain: "any error", code: 1)
        URLProtocolStub.stub(url: url, error: expectedError)
        
        let sut = URLSessionHTTPClient()
        
        let exp = expectation(description: "Wait for completion")
        
        sut.get(from: url) { result in
            switch result {
            case .failure(let receivedError as NSError):
                XCTAssertNotNil(receivedError)
                // update for iOS 14+
                XCTAssertEqual(receivedError.domain, expectedError.domain)
                XCTAssertEqual(receivedError.code, expectedError.code)
                // below iOS 14:
                // XCTAssertEqual(receivedError, expectedError)
            default:
                XCTFail("Expected failure with error \(expectedError), got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        // unregister in the end of test so that we don't stubbing other test requests
        URLProtocolStub.stopInterceptingRequests()
    }
    
    // MARK: - Helpers
    
    private class URLProtocolStub: URLProtocol {
        private static var stubs = [URL: Stub]()
        
        private struct Stub {
            let error: Error?
        }
        
        static func stub(url: URL, error: Error? = nil) {
            URLProtocolStub.stubs[url] = Stub(error: error)
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            URLProtocolStub.stubs = [:]
        }
        
        // if we return true, it means we can handle this request and now
        // it's our responsibility to complete the request with either success or failure
        // it means we intercept this request and we had control over its fate
        override class func canInit(with request: URLRequest) -> Bool {
            guard let url = request.url else { return false }
            
            return URLProtocolStub.stubs[url] != nil
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        // it means that the framework has accepted that we are going to handle this request
        // and now it's going to invoke us to say "now it's time for you to start loading the URL"
        override func startLoading() {
            guard
                let url = request.url, // request is an instance variable of URLProtocol
                let stub = URLProtocolStub.stubs[url]
            else { return }
            
            if let error = stub.error {
                // client is a property of URLProtocol
                // tell the URL Loading System that we failed with an error
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            // finish the loading in the end of this handler
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() { }
    }
    
}
