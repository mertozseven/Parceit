//
//  UIView.swift
//  Parceit
//
//  Created by Mert Ozseven on 16.12.2024.
//

import UIKit

extension UIView {
    
    // MARK: Keyboard dismiss method
    func addDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        addGestureRecognizer(tapGesture)
    }
    
}
