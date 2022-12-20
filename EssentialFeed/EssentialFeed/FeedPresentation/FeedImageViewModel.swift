//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 06/11/22.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    
    public var hasLocation: Bool {
        return location != nil
    }
}
