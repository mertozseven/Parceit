//
//  ContainerView.swift
//  Parceit
//
//  Created by Mert Ozseven on 9.12.2024.
//

import UIKit

final class ContainerView: UIView {
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(
        backgroundColor: UIColor = .systemBackground,
        cornerRadius: CGFloat = 0
    ) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
    }
}
