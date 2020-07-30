//
//  TappableView.swift
//  VAMusicPlayerAnimation
//
//  Created by Vikash Anand on 31/07/20.
//

import UIKit

final class TappableView: UIView {

    var completion:(()->Void)?
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(tapGesture)
    }

    @objc func viewTapped() {
        self.completion?()
    }

}
