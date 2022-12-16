//
//  RemoteImageCommentsLoader.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 16/12/22.
//

import Foundation

public typealias RemoteImageCommentsLoader = RemoteLoader<[ImageComment]>

extension RemoteImageCommentsLoader {
    public convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: ImageCommentsMapper.map)
    }
}
