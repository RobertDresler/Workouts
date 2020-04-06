//
//  RxSwift+Extension.swift
//  core
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import RxCocoa
import RxSwift

infix operator <->

public func <-><T> (property: ControlProperty<T>, variable: BehaviorRelay<T>) -> Disposable {
    let variableToProperty = variable.asObservable()
        .bind(to: property)

    let propertyToVariable = property
        .subscribe(onNext: { variable.accept($0) },
                   onCompleted: { variableToProperty.dispose() })

    return Disposables.create(variableToProperty, propertyToVariable)
}

public extension Observable {
    func subscribeNext(block: @escaping (Element) -> Void) -> Disposable {
        return self.subscribe {
            if let nextElement = $0.event.element {
                block(nextElement)
            }
        }
    }
}
