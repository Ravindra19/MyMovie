//
//  AuthenticationService.swift
//  My Movie
//
//  Created by Ravindra Gaikwad on 01/07/24.
//

import Foundation

import Foundation
import FirebaseCore
import FirebaseAuth
import CryptoKit
import AuthenticationServices
import GoogleSignIn

class AuthenticationService {
    
    static let sharedInstance = AuthenticationService()
//    var signInSuccess: ((_ user: GIDGoogleUser?) -> Void)?
//    var signInFailure: ((_ error: String) -> Void)?
    
    func googleSignIn(signInSuccess: @escaping ((_ user: GIDGoogleUser?) -> Void), signInFailure: @escaping ((_ error: String) -> Void)) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // As you’re not using view controllers to retrieve the presentingViewController, access it through
        // the shared instance of the UIApplication
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: rootViewController) { [unowned self] user, error in
            
            if let error = error {
                print("Error doing Google Sign-In, \(error)")
                signInFailure(error.localizedDescription)
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                signInFailure(error?.localizedDescription ?? "Login Error")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            
            // Authenticate with Firebase
            Auth.auth().signIn(with: credential) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                    signInFailure(e.localizedDescription)
                    return
                }
                
                signInSuccess(user)
            }
        }
    }
}
