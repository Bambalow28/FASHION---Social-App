//
//  ViewController.swift
//  FASHION
//
//  Created by Joshua Alanis on 2020-07-24.
//  Copyright © 2020 Joshua Alanis. All rights reserved.
//
import Foundation
import UIKit
import FirebaseDatabase
import Firebase

class ViewController: UIViewController {
    
    //References for variables
    @IBOutlet var loginView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var enterBtn: customButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var retrievedKey = [String]()
    var forgotAccountPassword: UITextField?
    
    struct getUserKey {
        static var userKey: String?
    }
    
    var ref: DatabaseReference!
    
    //Makes status bar light
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.checkLoggedIn()) {
            
            print("I remember you!")
            showSpinner(onView: self.view)
            
            let sec = 0.1
            DispatchQueue.main.asyncAfter(deadline: .now() + sec)
            {
                self.removeSpinner()
                self.transitionToHome()
            }
            
        }
        view.addSubview(enterBtn)
        
        email.attributedPlaceholder = NSAttributedString(string: "Email",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        password.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        ref = Database.database().reference()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
            
            view.addGestureRecognizer(tap)
        
        enterBtn.layer.cornerRadius = 10
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 130
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_textFeld: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func forgotPasswordClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "Enter Email", message: nil, preferredStyle: .alert)
        
        let passwordReset = UIAlertAction(title: "Reset", style: .default, handler: self.passwordReset)
        let cancelReset = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField(configurationHandler: forgotEmailTextfield)
        
        alert.addAction(passwordReset)
        alert.addAction(cancelReset)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //When enterBtn is pressed then it enters new view Controller and makes it the root view
    @IBAction func loginPressed(_ sender: Any)
    {
        self.pulsate()

        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (signedIn, error) in
            
            if error != nil
            {
                let alert = UIAlertController(title: "Oops!", message: "Something Went Wrong!", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))

                self.present(alert, animated: true)
            }
            
            else
            {
                self.enterBtn.layer.backgroundColor = UIColor.systemGreen.cgColor
                
                self.enterBtn.setTitle("Success!", for: .normal)

                UserDefaults.standard.set(true, forKey: "checkLoggedIn")
                UserDefaults.standard.synchronize()
                
                print("Thanks! Ill remember you!")
                
                let sec = 1.0
                DispatchQueue.main.asyncAfter(deadline: .now() + sec)
                {
                    self.transitionToHome()
                }

            }
            
        }
    }
    @IBAction func signUpClicked(_ sender: Any) {
        
        signUpBtn()
        
    }
    
    fileprivate func checkLoggedIn() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "checkLoggedIn")
        
    }
    
    func forgotEmailTextfield(textField: UITextField!) {
        forgotAccountPassword = textField
        forgotAccountPassword?.placeholder = "Enter Email..."
    }
    
    func passwordReset(alert: UIAlertAction!) {
        let auth = Auth.auth()
        let emailAddress = forgotAccountPassword?.text;

        auth.sendPasswordReset(withEmail: emailAddress!) { (error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let emailNotFound = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                
                alert.addAction(emailNotFound)
                
                self.present(alert, animated: true, completion: nil)
                return
            }
            else {
                let alert = UIAlertController(title: "Success!", message: "Check your email to Reset Password!", preferredStyle: .alert)
                
                let passwordReset = UIAlertAction(title: "Thanks!", style: .default, handler: nil)
                
                alert.addAction(passwordReset)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func transitionToHome() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainHome") as! mainHome

        let navController = UINavigationController(rootViewController: newViewController)
        
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.black
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        loginView = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.loginView?.removeFromSuperview()
            self.loginView = nil
        }
    }
    
    func signUpBtn() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "signupHome") as! signupHome
        
        newViewController.modalPresentationStyle = .overCurrentContext
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func pulsate() {
            
            let pulse = CASpringAnimation(keyPath: "transform.scale")
            pulse.duration = 0.6
            pulse.fromValue = 0.95
            pulse.toValue = 1.0
            pulse.autoreverses = true
            pulse.repeatCount = 2
            pulse.initialVelocity = 0.5
            pulse.damping = 1.0
            
        enterBtn.layer.add(pulse, forKey: "pulse")
        }
}








