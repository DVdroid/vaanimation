//
//  ModalViewController.swift
//  VAMusicPlayerAnimation
//
//  Created by Vikash Anand on 30/07/20.
//

import UIKit

class ModalViewController: UIViewController {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func dismissModalVC() {
        self.dismiss(animated: true)
    }
}
