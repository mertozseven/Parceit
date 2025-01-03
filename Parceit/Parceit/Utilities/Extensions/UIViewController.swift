//
//  UIViewController.swift
//  Parceit
//
//  Created by Mert Ozseven on 16.12.2024.
//

import UIKit

extension UIViewController {
    
    // MARK: - Keyboard dismiss method
    func addDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
}
