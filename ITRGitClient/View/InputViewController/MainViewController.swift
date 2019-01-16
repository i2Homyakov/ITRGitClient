//
//  MainViewController.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 14/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet private weak var parametersLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var getCommentsButton: UIButton!
    @IBOutlet private weak var logTextView: UITextView!

    private let provider = DefaultMainProvider()
    private let fileNotSaved = "file not saved"

    override func viewDidLoad() {
        super.viewDidLoad()
        showParameters()
    }

    // MARK: - Events

    @IBAction func commentsAction(_ sender: Any) {
        getCommentsButton.isEnabled = false
        logTextView.text = nil
        getFilteredPRs()
    }

    // MARK: - private

    private func showComments(_ comments: [PRComment]) {
        let text = CommentsFormatter.stringForComments(comments)
        logTextView.text = text

        let fileText = AppInputDataFormatter.getString() + "\n" + text
        if !LogsManager.saveText(fileText) {
            print(fileNotSaved)
        }
    }

    private func getFilteredPRs() {
        guard let password = passwordTextField.text, !password.isEmpty else {
            return
        }

        provider.getFilteredCommentsFor(password: password) { (comments, error) in
            DispatchQueue.main.async { [weak self] in
                self?.getCommentsButton.isEnabled = true

                if let error = error {
                    self?.logTextView.text = error.localizedDescription
                    return
                }

                self?.getCommentsButton.isEnabled = true
                self?.showComments(comments)
            }
        }
    }

    private func showParameters() {
        parametersLabel.text = AppInputDataFormatter.getString()
    }
}
