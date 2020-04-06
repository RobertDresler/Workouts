//
//  BViewModel.swift
//  Workouts
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import RxSwift

protocol BViewModel: class {
    var bag: DisposeBag { get }
    var title: String { get }
}

extension BViewModel {
    var bag: DisposeBag {
        fatalError("Should be declared in class.")
    }

    var title: String {
        return ""
    }
}
