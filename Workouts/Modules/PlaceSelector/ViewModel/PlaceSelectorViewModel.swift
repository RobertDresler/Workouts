//
//  PlaceSelectorViewModel.swift
//  Workouts
//
//  Created by Robert Dresler on 07/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import MapKit
import RxCocoa
import WorkoutsUI

final class PlaceSelectorViewModel: NSObject, BViewModel {

    typealias DataSourceItem = (model: MKLocalSearchCompletion, viewModel: PlaceCellViewModel)

    let dataSource = BehaviorRelay<[DataSourceItem]>(value: [])
    lazy var searchCompleter: MKLocalSearchCompleter = {
        let searchCompleter = MKLocalSearchCompleter()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .pointOfInterest
        searchCompleter.region = MKCoordinateRegion(MKMapRect.world)
        return searchCompleter
    }()

}

extension PlaceSelectorViewModel: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchCompleter.queryFragment = searchController.searchBar.text ?? ""
    }
}

extension PlaceSelectorViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        process(with: completer.results)
    }

    private func process(with results: [MKLocalSearchCompletion]) {
        dataSource.accept(results.map { ($0, viewModel(for: $0)) })
    }

    private func viewModel(for result: MKLocalSearchCompletion) -> PlaceCellViewModel {
        return PlaceCellViewModel(
            title: createHighlightedString(text: result.title, rangeValues: result.titleHighlightRanges)
        )
    }

    private func createHighlightedString(text: String, rangeValues: [NSValue]) -> NSAttributedString {
        let highlightedString = NSMutableAttributedString(string: text)

        let ranges = rangeValues.map { $0.rangeValue }
        ranges.forEach { range in
            highlightedString.addAttributes([.backgroundColor: Color.placeSelectorHighlight], range: range)
        }

        return highlightedString
    }
}
