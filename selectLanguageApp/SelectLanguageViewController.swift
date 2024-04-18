//
//  SelectLanguageViewController.swift
//  selectLanguageApp
//
//  Created by Takashi Nomura on 2024/04/18.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import LanguageManager_iOS


class SelectLanguageViewController: UIViewController {
    var viewModel: LanguageSelectionViewModel!

      @IBOutlet weak var japaneseButton: UIButton!
      @IBOutlet weak var englishButton: UIButton!

    private let disposeBag = DisposeBag()

        override func viewDidLoad() {
            super.viewDidLoad()
            bindUI()
        }
        
        func bindUI() {
            japaneseButton.rx.tap
                .map { "ja" }
                .bind(to: viewModel.selectLanguage)
                .disposed(by: disposeBag)
            englishButton.rx.tap
                .map { "en" }
                .bind(to: viewModel.selectLanguage)
                .disposed(by: disposeBag)
            viewModel.shouldDismiss
                .subscribe(onNext: { [weak self] _ in
                    self?.dismiss(animated: true, completion: nil)
                })
                .disposed(by: disposeBag)
        }
    }

class LanguageSelectionViewModel {

    // 言語選択イベントを発行するためのSubject
    let selectLanguage: PublishSubject<String> = PublishSubject()

    // UIを閉じるべきかどうかを伝えるためのSubject
    let shouldDismiss: Observable<Void>
 
    private let disposeBag = DisposeBag()

    init() {
        // 言語選択を購読して、言語設定を更新する
        shouldDismiss = selectLanguage
            .do(onNext: { languageCode in
                
                LanguageManager.shared.setLanguage(language: Languages(rawValue: languageCode) ?? .en)

            })
            .map { _ in Void() }
            .share()
        


    }
}


