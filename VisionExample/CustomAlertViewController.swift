//
//  CustomAlertViewController.swift
//  AIBVision5
//
//  Created by 綿貫直志 on 2025/10/12.
//  Copyright © 2025 Google Inc. All rights reserved.
//

import UIKit

class CustomAlertViewController: UIViewController {
    
    private let alertTitle: String
    private let alertMessage: String
    private var actions: [AlertAction] = []
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let scrollView = UIScrollView()
    private let actionsStackView = UIStackView()
    
    struct AlertAction {
        let title: String
        let style: UIAlertAction.Style
        let isEnabled: Bool
        let handler: (() -> Void)?
    }
    
    init(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        // print("🔵 CustomAlert initialized")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print("🔵 viewDidLoad called")
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // print("🔵 viewWillAppear called, actions count: \(actions.count)")
        setupActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // print("🔵 viewDidAppear called")
        // print("🔵 actionsStackView subviews count: \(actionsStackView.arrangedSubviews.count)")
        
        // レイアウト情報をデバッグ出力
        // print("📐 containerView frame: \(containerView.frame)")
        // print("📐 scrollView frame: \(scrollView.frame)")
        // print("📐 actionsStackView frame: \(actionsStackView.frame)")
        // print("📐 messageLabel frame: \(messageLabel.frame)")
        // print("📐 scrollView contentSize: \(scrollView.contentSize)")
        
        // 各ボタンのフレームも確認
        // for (index, subview) in actionsStackView.arrangedSubviews.enumerated() {
        // print("📐 Button \(index) frame: \(subview.frame)")
        // }
    }
    
    func addAction(title: String, style: UIAlertAction.Style = .default, isEnabled: Bool = true, handler: (() -> Void)?) {
        let action = AlertAction(title: title, style: style, isEnabled: isEnabled, handler: handler)
        actions.append(action)
        // print("🟢 Action added: \(title), total actions: \(actions.count)")
    }
    
    func finalizeActions() {
        // print("🟡 finalizeActions called, actions count: \(actions.count)")
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        
        containerView.backgroundColor = UIColor.systemBackground
        containerView.layer.cornerRadius = 14
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        titleLabel.text = alertTitle
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        messageLabel.text = alertMessage
        messageLabel.font = UIFont.systemFont(ofSize: 13)
        messageLabel.textAlignment = .center
        messageLabel.textColor = .secondaryLabel
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageLabel)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        containerView.addSubview(scrollView)
        
        actionsStackView.axis = .vertical
        actionsStackView.spacing = 0
        actionsStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(actionsStackView)
        
        // 制約を修正
        NSLayoutConstraint.activate([
            // 背景ビュー
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // コンテナビュー
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            // タイトル
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // メッセージ
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // スクロールビュー（高さの制約を明示的に設定）
            scrollView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // アクションスタックビュー
            actionsStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            actionsStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            actionsStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            actionsStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            actionsStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // containerViewの高さを計算して設定（タイトル + メッセージ + スクロール領域）
        // 最大高さは画面の70%
        let maxScrollHeight: CGFloat = 400
        // let headerHeight: CGFloat = 20 + 8 + 20 // top padding + spacing + bottom padding
        let maxContainerHeight = view.bounds.height * 0.7
        
        // スクロールビューの高さを制限
        let scrollHeightConstraint = scrollView.heightAnchor.constraint(equalToConstant: maxScrollHeight)
        scrollHeightConstraint.priority = .defaultHigh
        scrollHeightConstraint.isActive = true
        
        // containerViewの最大高さ
        let containerHeightConstraint = containerView.heightAnchor.constraint(lessThanOrEqualToConstant: maxContainerHeight)
        containerHeightConstraint.isActive = true
        
        // print("🔵 setupUI completed")
    }
    
    private func setupActions() {
        // print("🟡 setupActions called, current actions: \(actions.count)")
        
        actionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        guard !actions.isEmpty else {
            // print("⚠️ Warning: actions array is empty!")
            return
        }
        
        for (index, action) in actions.enumerated() {
            // print("🟡 Creating button for: \(action.title)")
            let button = createActionButton(for: action, isLast: index == actions.count - 1)
            actionsStackView.addArrangedSubview(button)
            // print("🟡 Button added to stack view")
        }
        
        //print("🟡 setupActions completed, stackView subviews: \(actionsStackView.arrangedSubviews.count)")
    }
    
    private func createActionButton(for action: AlertAction, isLast: Bool) -> UIButton {
        let button = UIButton(type: .system)
        
        // iOS 15以降の新しい設定方法を使用
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.title = action.title
            config.baseForegroundColor = action.isEnabled ? .systemBlue : .systemGray
            
            if action.style == .cancel {
                config.titleAlignment = .center
                config.background.backgroundColor = UIColor.secondarySystemBackground
            } else {
                config.titleAlignment = .leading
                config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                config.background.backgroundColor = .clear
            }
            
            // フォント設定
            let font: UIFont = action.style == .cancel ?
            UIFont.systemFont(ofSize: 17, weight: .semibold) :
            UIFont.systemFont(ofSize: 17, weight: .regular)
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = font
                return outgoing
            }
            
            button.configuration = config
        } else {
            // iOS 15未満の古い方法（警告が出るが互換性のため）
            button.setTitle(action.title, for: .normal)
            
            if action.style == .cancel {
                button.contentHorizontalAlignment = .center
                button.backgroundColor = UIColor.secondarySystemBackground
            } else {
                button.contentHorizontalAlignment = .left
                button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
                button.backgroundColor = .clear
            }
            
            button.titleLabel?.font = action.style == .cancel ?
            UIFont.systemFont(ofSize: 17, weight: .semibold) :
            UIFont.systemFont(ofSize: 17, weight: .regular)
            
            button.setTitleColor(action.isEnabled ? .systemBlue : .systemGray, for: .normal)
        }
        
        button.isEnabled = action.isEnabled
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        if !isLast {
            let separator = UIView()
            separator.backgroundColor = .separator
            separator.translatesAutoresizingMaskIntoConstraints = false
            button.addSubview(separator)
            
            NSLayoutConstraint.activate([
                separator.heightAnchor.constraint(equalToConstant: 0.5),
                separator.leadingAnchor.constraint(equalTo: button.leadingAnchor),
                separator.trailingAnchor.constraint(equalTo: button.trailingAnchor),
                separator.bottomAnchor.constraint(equalTo: button.bottomAnchor)
            ])
        }
        
        button.addAction(UIAction { [weak self] _ in
            print("🔴 Button tapped: \(action.title)")
            self?.dismiss(animated: true) {
                action.handler?()
            }
        }, for: .touchUpInside)
        
        return button
    }
}
