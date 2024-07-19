//
//  LoginViewController.swift
//  My Movie
//
//  Created by Ravindra Gaikwad on 01/07/24.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: on click of google sign in button checking whether user is already logged in or not if yes then directly moving to home/dashboard screen
    @IBAction func signInAction(_ sender: Any) {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            guard let homeScreenVc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenViewController") as? HomeScreenViewController else {
                return
            }
            self.navigationController?.pushViewController(homeScreenVc, animated: true)
        } else {
            self.login()
        }
    }
    
    //MARK: Function for firebae google signIn
    private func login() {
        AuthenticationService().googleSignIn(signInSuccess: { user in
            guard let homeScreenVc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenViewController") as? HomeScreenViewController else {
                return
            }
            self.navigationController?.pushViewController(homeScreenVc, animated: true)
        }, signInFailure: { errorMessage in
            print(errorMessage)
        })
    }
}
