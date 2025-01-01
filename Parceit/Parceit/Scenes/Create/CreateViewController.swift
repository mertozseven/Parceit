//
//  CreateViewController.swift
//  Parceit
//
//  Created by Mert Ozseven on 13.12.2024.
//

import UIKit
import SnapKit

final class CreateViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: CreateViewModel? {
        didSet {
            qrCodeTableView.reloadData()
            updateEmptyState()
        }
    }
    
    private lazy var qrCodeTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorEffect = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(QRCodeCell.self, forCellReuseIdentifier: QRCodeCell.identifier)
        
        return tableView
    }()
    
    private let addButton: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 52, weight: .regular)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: config)?.withTintColor(.accent, renderingMode: .alwaysOriginal)
        imageView.image = image
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 26
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private let emptyView: EmptyView = {
        let view = EmptyView()
        view.isHidden = true
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateEmptyState()
    }
    
    // MARK: - Inits
    init(viewModel: CreateViewModel? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        addViews()
        configureLayout()
        view.backgroundColor = .dynamicColor(light: .secondarySystemBackground, dark: .systemBackground)
        qrCodeTableView.reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addButtonTapped))
        addButton.addGestureRecognizer(tapGesture)
        
        view.addDismissKeyboardGesture()
        
        emptyView.configure(with: "Previous Codes", body: "Couldn't find previous codes. Please tap to plus button to add a new code")
    }
    
    private func addViews() {
        view.addSubview(qrCodeTableView)
        view.addSubview(emptyView)
        view.addSubview(addButton)
    }
    
    private func configureLayout() {
        qrCodeTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(240)
        }
        
        addButton.snp.makeConstraints {
            $0.height.width.equalTo(52)
            $0.trailing.equalTo(view.layoutMarginsGuide.snp.trailing).inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
        
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        addButton.layer.shadowRadius = 3
        addButton.layer.shadowOpacity = 0.3
    }
    
    @objc private func addButtonTapped() {
        let addCodeVC = AddCodeViewController(viewModel: viewModel)
        addCodeVC.delegate = self
        addCodeVC.modalPresentationStyle = .pageSheet
        present(addCodeVC, animated: true)
    }
    
    private func updateEmptyState() {
        let isEmpty = viewModel?.savedCodes?.isEmpty ?? true
        emptyView.isHidden = !isEmpty
        qrCodeTableView.isHidden = isEmpty
    }
    
}

// MARK: - UITableViewDataSource Methods
extension CreateViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.savedCodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QRCodeCell.identifier, for: indexPath) as? QRCodeCell else {
            return UITableViewCell()
        }
        if let selectedCell = viewModel?.savedCodes?.reversed()[indexPath.row] {
            cell.configure(with: selectedCell.title, qrCodeString: selectedCell.qrCodeString)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate Methods
extension CreateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        292
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension CreateViewController: AddCodeViewControllerDelegate {
    func didAddQRCode(_ qrCode: QRCode) {
        if viewModel?.savedCodes == nil {
            viewModel?.savedCodes = []
        }
        viewModel?.savedCodes?.append(qrCode)
        qrCodeTableView.reloadData()
        updateEmptyState()
    }
}
