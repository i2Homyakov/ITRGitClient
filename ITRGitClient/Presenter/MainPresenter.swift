//
//  MainPresenter.swift
//  ITRGitClient
//
//  Created by Homyakov, Ilya2 on 17/01/2019.
//  Copyright © 2019 Homyakov, Ilya2. All rights reserved.
//

import Foundation

protocol MainPresenter {

    func showParameters()
    func getFilteredCommentsForPassword(_ password: String)
}

class DefaultMainPresenter {

    private let fileNotSaved = "file not saved"

    private let provider: MainProvider
    private weak var view: MainView?

    init(view: MainView, provider: MainProvider) {
        self.provider = provider
        self.view = view
    }
}

extension DefaultMainPresenter: MainPresenter {

    func showParameters() {
        view?.showParametersText(AppInputDataFormatter.getText())
    }

    func getFilteredCommentsForPassword(_ password: String) {
        view?.showProgress()
        view?.clearLog()
        provider.getFilteredCommentsFor(password: password) { (comments, error) in
            DispatchQueue.main.async { [weak self] in
                if let error = error {
                    self?.showError(error)
                } else {
                    self?.showComments(comments)
                }

                self?.view?.hideProgress()
            }
        }
    }

    private func showError(_ error: Error) {
        view?.showLog(error.localizedDescription)
    }

    private func showComments(_ comments: [LogComment]) {
        let text = CommentsFormatter.textForComments(comments)
        view?.showLog(text)

        let fileText = AppInputDataFormatter.getText() + "\n\n" + text
        if !LogsManager.saveText(fileText) {
            print(fileNotSaved)
        }
    }
}
