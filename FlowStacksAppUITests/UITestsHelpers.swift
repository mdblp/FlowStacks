//
//  UITestsHelpers.swift
//  FlowStacksAppUITests
//
//  Created by Renaud Pradenc on 02/08/2022.
//

import Foundation
import XCTest


extension XCUIElement {
    /// Waits the amount of time you specify for the element’s ``isHittable``  property to become ``true``.
    ///
    /// @returns false if the timeout expires without the element becoming hittable.
    func waitForHittable(timeout: TimeInterval) -> Bool {
        let start = Date()
        let end = start + timeout

        var isTimedOut = false
        repeat {
            isTimedOut = Date() > end
        } while(!self.isHittable && !isTimedOut)

        return !isTimedOut
    }
}
