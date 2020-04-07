//
//  PlaceSelectorView.swift
//  Workouts
//
//  Created by Robert Dresler on 07/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core

protocol PlaceSelectorViewDelegate: class {
    func didSelectPlace(_ place: String)
    func placeSelectorViewDidTapCancelButton()
    func placeSelectorViewWillBeDeinitialized()
}

protocol PlaceSelectorView: BaseView {
    var delegate: PlaceSelectorViewDelegate? { get set }
}
