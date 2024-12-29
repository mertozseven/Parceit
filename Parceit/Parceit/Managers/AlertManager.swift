//
//  AlertManager.swift
//  Parceit
//
//  Created by Mert Ozseven on 28.12.2024.
//

import UIKit

final class AlertManager {
    private static func showAlert(title: String, message: String?, viewController: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Show Validation Alerts
extension AlertManager {
    
    public static func showInvalidEmailAlert(on viewController: UIViewController) {
        showAlert(title: "Invalid Email", message: "Please enter a valid email address.", viewController: viewController)
    }
    
    public static func showInvalidPasswordAlert(on viewController: UIViewController) {
        showAlert(title: "Invalid Password", message: "Please enter a valid password.", viewController: viewController)
    }
    
}

// MARK: - Registration Errors
extension AlertManager {
    
    public static func showRegistrationErrorAlert(on viewController: UIViewController) {
        showAlert(title: "Unknown Registration Alert", message: nil, viewController: viewController)
    }
    
    public static func showRegistrationErrorAlert(on viewController: UIViewController, with error: Error) {
        showAlert(title: "Invalid Email", message: "\(error.localizedDescription)", viewController: viewController)
    }
    
}

// MARK: - Usernames Errors
extension AlertManager {
    
    public static func showInvalidUsernameAlert(on viewController: UIViewController) {
        showAlert(title: "Invalid Username", message: "Please enter a valid username.", viewController: viewController)
    }
    
}

// MARK: - Log In Errors
extension AlertManager {
    
    public static func showSignInErrorAlert(on viewController: UIViewController) {
        showAlert(title: "Unknown Error Signing In", message: nil, viewController: viewController)
    }
    
    public static func showSignInErrorAlert(on viewController: UIViewController, with error: Error) {
        showAlert(title: "Error Signing In", message: "\(error.localizedDescription)", viewController: viewController)
    }
    
}

// MARK: - Log Out Errors
extension AlertManager {
    
    public static func showSignOutErrorAlert(on viewController: UIViewController, with error: Error) {
        showAlert(title: "Unknown Error Signing Out", message: "\(error.localizedDescription)", viewController: viewController)
    }
    
}

// MARK: - Forgot Password Errors
extension AlertManager {
    
    public static func showPasswordResetSent(on viewController: UIViewController) {
        showAlert(title: "Password Reset Sent", message: nil, viewController: viewController)
    }
    
    public static func showErrorSendingPasswordReset(on viewController: UIViewController, with error: Error) {
        showAlert(title: "Error Sending Password Reset", message: "\(error.localizedDescription)", viewController: viewController)
    }
    
}

// MARK: - Fetching User Errors
extension AlertManager {
    
    public static func showFetchingUserError(on viewController: UIViewController, with error: Error) {
        showAlert(title: "Error Fetching User", message: "\(error.localizedDescription)", viewController: viewController)
    }
    
    public static func showUnknownFetchingUserError(on viewController: UIViewController, with error: Error) {
        showAlert(title: "Error UnknownFetching User", message: "\(error.localizedDescription)", viewController: viewController)
    }
    
}
