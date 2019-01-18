//
//  MainViewController.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 14/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import UIKit

protocol MainView: class {

    func showParametersText(_ text: String)
    func showLog(_ log: String)
    func clearLog()
    func showProgress()
    func hideProgress()
}

class MainViewController: UIViewController {

    @IBOutlet private weak var parametersLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var getCommentsButton: UIButton!
    @IBOutlet private weak var logTextView: UITextView!

    var presenter: MainPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.showParameters()
    }

    // MARK: - Events

    @IBAction func commentsAction(_ sender: Any) {
        guard let password = passwordTextField.text, !password.isEmpty else {
            return
        }
        presenter?.getFilteredCommentsForPassword(password)
    }
}

extension MainViewController: MainView {

    func showParametersText(_ text: String) {
        parametersLabel.text = text
    }

    func showLog(_ log: String) {
        logTextView.text = log
    }

    func clearLog() {
        logTextView.text = nil
    }

    func showProgress() {
        getCommentsButton.isEnabled = false
    }

    func hideProgress() {
        getCommentsButton.isEnabled = true
    }
}
