//
//  Copyright 2019 patrickbdev
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

public extension UIView {

    var inputLayoutGuide: InputLayoutGuide {
        let identifier = "InputLayoutGuide"
        return layoutGuides.first(where: { $0.identifier == identifier }) as? InputLayoutGuide ?? InputLayoutGuide(view: self, identifier: identifier)
    }
}

public class InputLayoutGuide: UILayoutGuide {

    private var heightConstraint: NSLayoutConstraint!
    
    init(view: UIView, identifier: String) {
        super.init()
        
        view.addLayoutGuide(self)
        self.identifier = identifier
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.isActive = true
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIWindow.keyboardWillChangeFrameNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard
            let keyboardNotification = KeyboardNotification(notification: notification),
            let owningView = owningView else {
                return
        }
        
        let keyboardFrame = owningView.convert(keyboardNotification.endFrame, from: owningView.window)
        let overlappedHeight = max(owningView.bounds.maxY - keyboardFrame.minY, 0)
        
        heightConstraint.constant = overlappedHeight
        
        UIView.animate(withDuration: keyboardNotification.duration, delay: 0, options: [.beginFromCurrentState, keyboardNotification.animationOptionCurve], animations: {
            owningView.layoutIfNeeded()
        })
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard
            let keyboardNotification = KeyboardNotification(notification: notification),
            let owningView = owningView else {
                return
        }
        
        heightConstraint.constant = 0
        
        UIView.animate(withDuration: keyboardNotification.duration, delay: 0, options: [.beginFromCurrentState, keyboardNotification.animationOptionCurve], animations: {
            owningView.layoutIfNeeded()
        })
    }
    
    @objc private func keyboardWillChangeFrame(notification: Notification) {
        guard
            let keyboardNotification = KeyboardNotification(notification: notification),
            let owningView = owningView else {
                return
        }
        
        heightConstraint.constant = 0
        
        UIView.animate(withDuration: keyboardNotification.duration, delay: 0, options: [.beginFromCurrentState, keyboardNotification.animationOptionCurve], animations: {
            owningView.layoutIfNeeded()
        })
    }
}

private struct KeyboardNotification {
    
    let duration: TimeInterval
    let endFrame: CGRect
    let animationOptionCurve: UIView.AnimationOptions
    
    init?(notification: Notification) {
        guard
            [UIWindow.keyboardWillShowNotification, UIWindow.keyboardWillHideNotification, UIWindow.keyboardWillChangeFrameNotification].contains(notification.name),
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let curveRawValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIView.AnimationCurve(rawValue: curveRawValue) else {
                return nil
        }
        
        let animationOptionCurve: UIView.AnimationOptions = {
            switch curve {
            case .easeIn:       return .curveEaseIn
            case .easeOut:      return .curveEaseOut
            case .easeInOut:    return .curveEaseInOut
            case .linear:       return .curveLinear
            default:            return .curveLinear
            }
        }()
        
        self.duration = duration
        self.endFrame = endFrame
        self.animationOptionCurve = animationOptionCurve
    }
}
