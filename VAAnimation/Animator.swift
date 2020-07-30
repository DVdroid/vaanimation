//
//  Animator.swift
//  VAMusicPlayerAnimation
//
//  Created by Vikash Anand on 30/07/20.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {

    static let duration: TimeInterval = 1.25

    private let type: PresentationType
    private let firstViewController: RootViewController
    private let secondViewController: ModalViewController
    private var selectedSmallIconViewSnapshot: UIView
    private let smallIconViewRect: CGRect

    var dismissCompletion: (()->Void)?

    private let smallIconViewLabelRect: CGRect

    init?(type: PresentationType, firstViewController: RootViewController, secondViewController: ModalViewController, selectedSmallIconViewSnapshot: UIView) {
        self.type = type
        self.firstViewController = firstViewController
        self.secondViewController = secondViewController
        self.selectedSmallIconViewSnapshot = selectedSmallIconViewSnapshot

        guard let window = firstViewController.view.window ?? secondViewController.view.window,
              let smallIconView = firstViewController.smallIconView
            else { return nil }

        self.smallIconViewRect = smallIconView.iconImageView.convert(smallIconView.iconImageView.bounds, to: window)
        self.smallIconViewLabelRect = smallIconView.nameLabel.convert(smallIconView.nameLabel.bounds, to: window)
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView
        guard let toView = secondViewController.view
            else {
                transitionContext.completeTransition(false)
                return
        }

        containerView.addSubview(toView)
        guard
            let smallIconView = firstViewController.smallIconView,
            let window = firstViewController.view.window ?? secondViewController.view.window,
            let smallIconViewSnapshot = smallIconView.iconImageView.snapshotView(afterScreenUpdates: true),
            let controllerImageViewSnapshot = secondViewController.iconImageView.snapshotView(afterScreenUpdates: true),
            let smallIconViewLabelSnapshot = smallIconView.nameLabel.snapshotView(afterScreenUpdates: true)
            else {
                transitionContext.completeTransition(true)
                return
        }

        let isPresenting = type.isPresenting
        let backgroundView: UIView
        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = secondViewController.view.backgroundColor


        if isPresenting {
            selectedSmallIconViewSnapshot = smallIconViewSnapshot
            backgroundView = UIView(frame: containerView.bounds)
            backgroundView.addSubview(fadeView)
            fadeView.alpha = 0
        } else {
            backgroundView = firstViewController.view.snapshotView(afterScreenUpdates: true) ?? fadeView
            backgroundView.addSubview(fadeView)
        }


        toView.alpha = 0
        [backgroundView, selectedSmallIconViewSnapshot, controllerImageViewSnapshot, smallIconViewLabelSnapshot].forEach { containerView.addSubview($0) }
        let controllerImageViewRect = secondViewController.iconImageView.convert(secondViewController.iconImageView.bounds, to: window)
        let controllerLabelRect = secondViewController.nameLabel.convert(secondViewController.nameLabel.bounds, to: window)
        [selectedSmallIconViewSnapshot, controllerImageViewSnapshot].forEach {
            $0.frame = isPresenting ? smallIconViewRect : controllerImageViewRect
            $0.layer.cornerRadius = isPresenting ? 12 : 0
            $0.layer.masksToBounds = true
        }

        controllerImageViewSnapshot.alpha = isPresenting ? 0 : 1
        selectedSmallIconViewSnapshot.alpha = isPresenting ? 1 : 0
        smallIconViewLabelSnapshot.frame = isPresenting ? smallIconViewLabelRect : controllerLabelRect


        UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: .calculationModeCubic, animations: {

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.selectedSmallIconViewSnapshot.frame = isPresenting ? controllerImageViewRect : self.smallIconViewRect
                controllerImageViewSnapshot.frame = isPresenting ? controllerImageViewRect : self.smallIconViewRect
                fadeView.alpha = isPresenting ? 1 : 0
                smallIconViewLabelSnapshot.frame = isPresenting ? controllerLabelRect : self.smallIconViewLabelRect
                [controllerImageViewSnapshot, self.selectedSmallIconViewSnapshot].forEach {
                    $0.layer.cornerRadius = isPresenting ? 0 : 12
                }
            }

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
                self.selectedSmallIconViewSnapshot.alpha = isPresenting ? 0 : 1
                controllerImageViewSnapshot.alpha = isPresenting ? 1 : 0
            }

        }, completion: { _ in
            self.selectedSmallIconViewSnapshot.removeFromSuperview()
            controllerImageViewSnapshot.removeFromSuperview()
            backgroundView.removeFromSuperview()
            smallIconViewLabelSnapshot.removeFromSuperview()
            toView.alpha = 1

            self.dismissCompletion?()
            transitionContext.completeTransition(true)
        })
    }

}

enum PresentationType {

    case none
    case present
    case dismiss

    var isPresenting: Bool {
        return self == .present
    }
}
