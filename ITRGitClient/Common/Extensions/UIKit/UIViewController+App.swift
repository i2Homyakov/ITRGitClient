//
//  UIViewController+App.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 17/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import UIKit

extension UIViewController {

    static func xibInstance<T: UIViewController>() -> T {
        let nibName = String(describing: self)
        return T(nibName: nibName, bundle: nil)
    }
}
