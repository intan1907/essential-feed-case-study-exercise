//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Intan Nurjanah on 02/11/22.
//

import EssentialFeed

// jika view yang implement `display(isLoading:)` dan implement `display(feed:)` berbeda,
// maka kedua fungsi tersebut tidak boleh ada dalam 1 protocol
// ketika mengubah closure menjadi protocol, usahakan untuk memetakannya 1 ke 1
// contoh: 2 closure -> 2 protocol
// (menjadi 1 protocol jika memang hanya ada kasus 1 object saja yg langsung implement keduanya)
protocol FeedLoadingView: AnyObject { // conform to class (sekarang pakai AnyObject), untuk bisa di-weakify
    func display(isLoading: Bool)
}

protocol FeedView {
    func display(feed: [FeedImage])
}

final class FeedPresenter {
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var feedView: FeedView?
    weak var loadingView: FeedLoadingView?
    
    func loadFeed() {
        loadingView?.display(isLoading: true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(feed: feed)
            }
            self?.loadingView?.display(isLoading: false)
        }
    }
}
