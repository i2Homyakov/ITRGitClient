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
        getFilteredPRsFor()
    }

    // MARK: - private

    private func showPullRequests(_ pullRequests: [PullRequestsValue]) {
        let lines = pullRequests.map {
            String(format: "%d %@", $0.identifier, $0.getCreatedDate().toStringFor(format: dateFormat))
        }
        logTextView.text = lines.joined(separator: "\n")
    }

    private func getFilteredPRsFor() {
        guard let password = passwordTextField.text else {
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
