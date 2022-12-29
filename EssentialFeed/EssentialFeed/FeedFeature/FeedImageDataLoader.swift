//
//  FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 01/11/22.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
