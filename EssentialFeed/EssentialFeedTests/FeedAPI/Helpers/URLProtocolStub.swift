//
//  URLProtocolStub.swift
//  EssentialFeedTests
//
//  Created by Intan Nurjanah on 10/11/22.
//

import Foundation

class URLProtocolStub: URLProtocol {
    private struct Stub {
        let data: Data?
        let response: URLResponse?
        let error: Error?
        let requestObserver: ((URLRequest) -> Void)?
    }
    
    private static var _stub: Stub?
    private static var stub: Stub? {
        get { return queue.sync { _stub } }
        set { queue.sync { _stub = newValue } }
    }
    
    private static let queue = DispatchQueue(label: "URLProtocolStub.queue")
    
    static func stub(data: Data?, response: URLResponse?, error: Error?) {
        stub = Stub(data: data, response: response, error: error, requestObserver: nil)
    }
    
    static func observeRequests(observer: @escaping (URLRequest) -> Void) {
        stub = Stub(data: nil, response: nil, error: nil, requestObserver: observer)
    }
    
    static func removeStub() {
        stub = nil
    }
    
    // if we return true, it means we can handle this request and now
    // it's our responsibility to complete the request with either success or failure
    // it means we intercept this request and we had control over its fate
    override class func canInit(with request: URLRequest) -> Bool {
        // in this line, we are capturing the request observer and invoke it.
        // unfortunately, `canInit(with:)` method is invoked before the request even
        // starts which means the `test_getFromURL_performsGETRequestWithURL` test method
        // will finish its execution before the request even started. so when the test
        // method returns, the request will still be running.
        // so ideally we should move this line to `startLoading()` method which is
        // the method that starts the URL request and where we can finish the `URLRequest`
        // `requestObserver?(request)`
        
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    // it means that the framework has accepted that we are going to handle this request
    // and now it's going to invoke us to say "now it's time for you to start loading the URL"
    override func startLoading() {
        guard let stub = URLProtocolStub.stub else { return }

        if let data = stub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = stub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = stub.error {
            // client is a property of URLProtocol
            // tell the URL Loading System that we failed with an error
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            // finish the loading if there is no error
            client?.urlProtocolDidFinishLoading(self)
        }
        
        stub.requestObserver?(request)
    }
    
    override func stopLoading() { }
}
