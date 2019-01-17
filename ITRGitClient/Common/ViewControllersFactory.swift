//
//  ViewControllersFactory.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 17/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

class ViewControllersFactory {

    static func makeMainViewController() -> MainViewController {
        let view: MainViewController = MainViewController.xibInstance()

        let presenter = DefaultMainPresenter(view: view, provider: DefaultMainProvider())
        view.presenter = presenter

        return view
    }
}
