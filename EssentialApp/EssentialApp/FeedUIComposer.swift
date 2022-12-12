//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Intan Nurjanah on 01/11/22.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class FeedUIComposer {
    private init() { }
    
    public static func feedComposedWith(feedLoader: @escaping () -> FeedLoader.Publisher, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: { feedLoader().dispatchOnMainQueue() })
        
        let feedController = makeFeedViewController(delegate: presentationAdapter, title: FeedPresenter.title)
        
        let presenter = FeedPresenter(
            feedView: FeedViewAdapter(
                controller: feedController,
                imageLoader: { imageLoader($0).dispatchOnMainQueue() }
            ),
            loadingView: WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController)
        )
        // ketika menemukan circular dependency pada 2 komponen (case ini `presentationAdapter` dan `presenter`), harus ada salah satu yg memakai property injection; tidak boleh keduanya constructor injection
        // tapi ketika melakukan property injection tidak boleh membocorkan composition detail dari komponen tsb
        // `presentationAdapter` dipilih sebagai komponen dengan property injection karena ia adalah bagian dari Composition layer. kita tidak membocorkan composition detail di sini karena adapter adalah composition component
        presentationAdapter.presenter = presenter
        return feedController
    }

    private static func makeFeedViewController(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.delegate = delegate
        feedController.title = title
        return feedController
    }
}
