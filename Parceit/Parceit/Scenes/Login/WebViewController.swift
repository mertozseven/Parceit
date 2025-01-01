//
//  WebViewController.swift
//  Parceit
//
//  Created by Mert Ozseven on 28.12.2024.
//

import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController {
    
    // MARK: - Properties
    private let webView = WKWebView()
    private var urlString: String
    
    // MARK: - Inits
    init(with urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureUrl()
    }
    
    // MARK: - Private Methods
    private func configureView() {
        addViews()
        configureLayout()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
    }
    
    private func addViews() {
        view.addSubview(webView)
    }
    
    private func configureLayout() {
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureUrl() {
        guard let url = URL(string: urlString) else {
            self.dismiss(animated: true)
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    // MARK: - Objective Methods
    @objc private func dismissVC() {
        dismiss(animated: true)
    }

}
