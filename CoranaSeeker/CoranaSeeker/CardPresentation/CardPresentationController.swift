//
//  CardPresentationController.swift
//  PerfectlyCrafted
//
//  Created by Ashli Rankin on 3/9/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import UIKit

/// `UIPresentationController` subclass which  manages the transition animations and the presentation of view controllers onscreen
final class CardPresentationController: UIPresentationController {
    
    /// The direction in which a controller can be presented in.
    enum PresentationDirection {
        /// Displays the presented controller in the center of it's parent.
        case center
        /// Displays the presented controller in the bottom of it's parent.
        case bottom
    }

    private var dimmingView: UIView!
    
    private var presentationDirection: PresentationDirection?
    
    /// Creates a new instance of the `CardPresentationController`
    /// - Parameters:
    ///   - presentedViewController: The controller being presented.
    ///   - presentingViewController: The controller which presents another.
    ///   - presentationDirection: The direction that a card should be presented.
    init(presentedViewController: UIViewController, presentingViewController: UIViewController?, presentationDirection: PresentationDirection?) {
        self.presentationDirection = presentationDirection
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    
    }
    
    override func presentationTransitionWillBegin() {
        guard let dimmingView = dimmingView, let containerView = containerView else {
            return
        }
        
        containerView.insertSubview(dimmingView, at: 0)
        
        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        
        switch presentationDirection ?? .center {
        case .center:
            return CGSize(width: parentSize.width, height: parentSize.height * (2.0 / 3.0))
        case .bottom:
            return CGSize(width: parentSize.width, height: parentSize.height * (1.0 / 3.0))
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: (containerView?.bounds.size)!)
        
        switch presentationDirection ?? .center {
        case .center:
            frame.origin.y = containerView!.frame.height * (1.0 / 3.0)
        case .bottom:
            frame.origin.y = containerView!.frame.height * (2.0 / 3.0)
        }
        return frame
    }
}

extension CardPresentationController {
    
   private func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(tapGestureRecognizer)
        dimmingView.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}
