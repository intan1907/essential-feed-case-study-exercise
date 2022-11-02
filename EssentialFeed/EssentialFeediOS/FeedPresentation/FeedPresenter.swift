//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Intan Nurjanah on 02/11/22.
//

import EssentialFeed

struct FeedLoadingViewModel {
    let isLoading: Bool
}

// jika view yang implement `display(isLoading:)` dan implement `display(feed:)` berbeda,
// maka kedua fungsi tersebut tidak boleh ada dalam 1 protocol
// ketika mengubah closure menjadi protocol, usahakan untuk memetakannya 1 ke 1
// contoh: 2 closure -> 2 protocol
// (menjadi 1 protocol jika memang hanya ada kasus 1 object saja yg langsung implement keduanya)
protocol FeedLoadingView {
    // dibuat menjadi data structure (ViewModel) agar konteksnya lebih jelas,
    // semula hanya memberikan parameter `Bool`, padahal secara konteks, ia memberikan model yang dibutuhkan untuk `FeedLoadingView`
    // + kelebihan menggunakan data structure: jika parameter bertambah, tidak akan merusak implementasi yang sudah ada
    func display(_ viewModel: FeedLoadingViewModel)
}

struct FeedViewModel {
    let feed: [FeedImage]
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

final class FeedPresenter {
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var feedView: FeedView?
    var loadingView: FeedLoadingView?
    
    func loadFeed() {
        loadingView?.display(FeedLoadingViewModel(isLoading: true))
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(FeedViewModel(feed: feed))
            }
            self?.loadingView?.display(FeedLoadingViewModel(isLoading: false))
        }
    }
}
