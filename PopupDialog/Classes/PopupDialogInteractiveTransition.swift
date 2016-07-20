//
//  PopupDialogInteractiveTransition.swift
//
//  Copyright (c) 2016 Orderella Ltd. (http://orderella.co.uk)
//  Author - Martin Wildfeuer (http://www.mwfire.de)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

// Handles interactive transition triggered via pan gesture recognizer on dialog
final internal class InteractiveTransition: UIPercentDrivenInteractiveTransition {

    // If the interactive transition was started
    var hasStarted = false

    // If the interactive transition
    var shouldFinish = false

    // The view controller containing the views
    // with attached gesture recognizers
    weak var viewController: UIViewController? = nil

    @objc func handlePan(sender: UIPanGestureRecognizer) {

        guard let vc = viewController else {
            return
        }

        // http://www.thorntech.com/2016/02/ios-tutorial-close-modal-dragging/
        let translation = sender.translationInView(vc.view)
        let verticalMovement = translation.y / vc.view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)

        switch sender.state {
        case .Began:
            hasStarted = true
            vc.dismissViewControllerAnimated(true, completion: nil)
        case .Changed:
            shouldFinish = progress > 0.35
            updateInteractiveTransition(progress)
        case .Cancelled:
            hasStarted = false
            cancelInteractiveTransition()
        case .Ended:
            hasStarted = false
            shouldFinish ? finishInteractiveTransition() : cancelInteractiveTransition()
        default:
            break
        }
    }
}
