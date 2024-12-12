//
//  UIColor.swift
//  Parceit
//
//  Created by Mert Ozseven on 9.12.2024.
//

import UIKit

extension UIColor {
    
    // MARK: - Set Dynamic Colors
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return light }
        return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }
    
}


