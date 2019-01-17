//
//  MainViewController.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 14/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var getCommentsButton: UIButton!
    @IBOutlet private weak var logTextView: UITextView!

    private let provider = DefaultPRsProvider()
    private let dateFormat = "dd-MM-yyyy"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Events

    @IBAction func commentsAction(_ sender: Any) {
        getCommentsButton.isEnabled = false
        logTextView.text = nil
        getFilteredPRs()
    }

    // MARK: - private

    private func showPullRequests(_ pullRequests: [PullRequest]) {
        let lines = pullRequests.map {
            String(format: "%d %@", $0.identifier, $0.getCreationDate().toStringFor(format: dateFormat))
        }
        logTextView.text = lines.joined(separator: "\n")
    }

    private func getFilteredPRs() {
        guard let password = passwordTextField.text, !password.isEmpty else {
            return
        }

        provider.getFilteredPRsFor(password: password, onCompletion: { (pullRequests, error) in
            DispatchQueue.main.async { [weak self] in
                self?.getCommentsButton.isEnabled = true

                if let error = error {
                    self?.logTextView.text = error.localizedDescription
                    return
                }

                self?.getCommentsButton.isEnabled = true
                self?.showPullRequests(pullRequests)
            }
        })
    }

}
