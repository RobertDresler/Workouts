//
//  CachedArray.swift
//  core
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import RealmSwift

public class CachedArray<RealmModel: RealmCollectionValue, ViewModel> {

    public var onDataChange: (() -> Void)?

    public var count: Int {
        return cachedArray.count
    }

    public typealias Item = (model: RealmModel, viewModel: ViewModel)

    public var results: Results<RealmModel> {
        didSet {
            setupObserving()
        }
    }
    private var cachedArray = [Item?]()
    private let makeViewModel: (RealmModel) -> ViewModel
    private var notificationToken: NotificationToken?

    public init(results: Results<RealmModel>, makeViewModel: @escaping (RealmModel) -> ViewModel) {
        self.results = results
        self.makeViewModel = makeViewModel
        setupObserving()
    }

    private func setupObserving() {
        notificationToken = results.observe { [weak self] _ in
            self?.reset()
        }
    }

    public func reset() {
        cachedArray = Array(repeating: nil, count: results.count)
        onDataChange?()
    }

    public subscript(index: Int) -> Item? {
        if let item = cachedArray[safe: index] as? Item {
            return item
        } else if let model = results[safe: index] {
            let item = Item(model, makeViewModel(model))
            cachedArray[index] = item
            return item
        } else {
            return nil
        }
    }

}
