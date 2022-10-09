//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 07/10/22.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
