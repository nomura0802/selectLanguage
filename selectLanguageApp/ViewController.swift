//
//  ViewController.swift
//  selectLanguageApp
//
//  Created by Takashi Nomura on 2024/04/18.
//

import UIKit
import RxSwift
import RxCocoa
import LanguageManager_iOS
class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var showLanguageButton: UIButton!
    private let disposeBag = DisposeBag()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    private func setupBindings() {
        updateTexts()
        
        showLanguageButton.rx.tap
            .bind { [weak self] in
                self?.presentLanguageSheet()
            }
            .disposed(by: disposeBag)
    }
    
    private func presentLanguageSheet() {
        let storyboard = UIStoryboard(name: "Sheet", bundle: nil)
        if let languageSelectorVC = storyboard.instantiateViewController(withIdentifier: "Sheet") as? SelectLanguageViewController {
            let viewModel = LanguageSelectionViewModel()
            languageSelectorVC.viewModel = viewModel
            viewModel.shouldDismiss
                .bind { [weak self] in
                    self?.updateTexts()
                }
                .disposed(by: disposeBag)

            languageSelectorVC.modalPresentationStyle = .formSheet
            self.present(languageSelectorVC, animated: true, completion: nil)
        }
    }

    private func updateTexts() {
        titleLabel.text = "select_language".localiz()
    }
}
