//
//  CardPresentationManager.swift
//  PerfectlyCrafted
//
//  Created by Ashli Rankin on 3/9/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import UIKit

final class CardPresentationManager: NSObject {
    
    /// The presentation direction.
    var presentationDirection: CardPresentationController.PresentationDirection = .center

}

extension CardPresentationManager: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CardPresentationController(presentedViewController: presented, presentingViewController: presenting, presentationDirection: presentationDirection)
    }
}
