//
//  ViewController.swift
//  VAAnimation
//
//  Created by Vikash Anand on 31/07/20.
//

import UIKit

class RootViewController: UIViewController {

    var selectedSmallIconViewSnapshot: UIView?
    @IBOutlet var smallIconView: TappableView!
    fileprivate var animator: Animator?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        smallIconView.completion = { [weak self] in
            self?.selectedSmallIconViewSnapshot = self?.smallIconView?.iconImageView.snapshotView(afterScreenUpdates: false)
            let modalVC = UIStoryboard.viewcontroller(ofType: ModalViewController.self)
            modalVC.transitioningDelegate = self
            modalVC.modalPresentationStyle = .fullScreen

            self?.present(modalVC, animated: true)
        }
    }
}

extension RootViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        guard let firstViewController = source as? RootViewController,
              let secondViewController = presented as? ModalViewController,
              let selectedSmallIconViewSnapshot = firstViewController.selectedSmallIconViewSnapshot else { return nil }

        self.smallIconView.isHidden = true
        animator = Animator(type: .present, firstViewController: firstViewController, secondViewController: secondViewController, selectedSmallIconViewSnapshot: selectedSmallIconViewSnapshot)

        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let secondViewController = dismissed as? ModalViewController,
            let selectedSmallIconViewSnapshot = selectedSmallIconViewSnapshot
            else { return nil }

        animator = Animator(type: .dismiss, firstViewController: self, secondViewController: secondViewController, selectedSmallIconViewSnapshot: selectedSmallIconViewSnapshot)
        animator?.dismissCompletion = {
            self.smallIconView.isHidden = false
        }
        return animator
    }
}

