//
//  UIStoryboard+Extension.swift
//  VAMusicPlayerAnimation
//
//  Created by Vikash Anand on 30/07/20.
//

import UIKit

extension UIStoryboard {

    class func viewcontroller<T>(ofType type: T.Type,
                                 fromStoryboardWithName name: String = "Main",
                                 inBundle bundleName: Bundle = Bundle.main) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        guard let viewcontroller = storyboard.instantiateViewController(withIdentifier: String(describing: type)) as? T else {
            fatalError("Viewcontroller of type \(String(describing: type)) not found in \(name) storyboard")
        }
        return viewcontroller
    }
}
