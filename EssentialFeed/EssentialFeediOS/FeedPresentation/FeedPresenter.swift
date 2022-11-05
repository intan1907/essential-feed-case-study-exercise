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
protocol FeedLoadingView {
    // dibuat menjadi data structure (ViewModel) agar konteksnya lebih jelas,
    // semula hanya memberikan parameter `Bool`, padahal secara konteks, ia memberikan model yang dibutuhkan untuk `FeedLoadingView`
    // + kelebihan menggunakan data structure: jika parameter bertambah, tidak akan merusak implementasi yang sudah ada
    func display(_ viewModel: FeedLoadingViewModel)
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

final class FeedPresenter {
    // pada MVP, Presenter harus punya View, jadi view abstraction di bawah tidak boleh optional
    private let feedView: FeedView
    private let loadingView: FeedLoadingView
    private let errorView: FeedErrorView
    
    // constructor injection memastikan bahwa suatu komponen memiliki dependencies yang ia butuhkan secara lifetime
    init(feedView: FeedView, loadingView: FeedLoadingView, errorView: FeedErrorView) {
        self.feedView = feedView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    static var title: String {
        return NSLocalizedString(
            "FEED_VIEW_TITLE",
            tableName: "Feed",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Title for the feed view"
        )
    }
    
    private var feedLoadError: String {
        return NSLocalizedString(
            "FEED_VIEW_CONNECTION_ERROR",
             tableName: "Feed",
             bundle: Bundle(for: FeedPresenter.self),
             comment: "Error message displayed when we can't load the image feed from the server"
        )
    }
    
    func didStartLoadingFeed() {
        errorView.display(FeedErrorViewModel(message: nil))
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingFeed(with error: Error) {
        errorView.display(FeedErrorViewModel(message: feedLoadError))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
