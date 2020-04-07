//
//  WorkoutPropertyCell.swift
//  Workouts
//
//  Created by Robert Dresler on 07/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import core
import RxSwift
import UIKit
import WorkoutsUI

class WorkoutPropertyCell: BCell {

    var bag = DisposeBag()

    let wrapperView = UIView()

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }

    override func setupView() {
        super.setupView()
        backgroundColor = Color.cellBackground
    }

    override func addSubviews() {
        super.addSubviews()
        contentView.addSubview(wrapperView)
    }

    override func setupConstraints() {
        super.setupConstraints()
        wrapperView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Padding.large)
            make.leading.trailing.equalTo(readableContentGuide)
        }
    }

}
