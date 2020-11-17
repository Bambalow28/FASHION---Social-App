//
//  signupHome.swift
//  FASHION
//
//  Created by Joshua Alanis on 2020-09-27.
//  Copyright © 2020 Joshua Alanis. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class signupHome: UIViewController {

    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var createBtn: customButton!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!

    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
            
            view.addGestureRecognizer(tap)
        
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibility.isReduceTransparencyEnabled {
            view.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            view.addSubview(blurEffectView)
            view.insertSubview(signupView, aboveSubview: blurEffectView)
            
        } else {
            view.backgroundColor = .black
        }
        
        signupView.layer.cornerRadius = 10
        signupView.layer.masksToBounds = true
        signupView.layer.borderWidth = 1.0
        signupView.layer.borderColor = UIColor.lightGray.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 100
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
    
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createClicked(_ sender: Any) {
        
        if(emailTxt.text == "")
        {
            self.createBtn.layer.backgroundColor = UIColor.systemRed.cgColor
            createBtn.setTitle("Error!", for: .normal)
            createBtn.shake()
            
            let sec = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + sec)
            {
                self.createBtn.layer.backgroundColor = UIColor.systemIndigo.cgColor
                self.createBtn.setTitle("Create", for: .normal)
            }
        }
        else if(passwordTxt.text == "")
        {
            self.createBtn.layer.backgroundColor = UIColor.systemRed.cgColor
            
            createBtn.setTitle("Error!", for: .normal)
            createBtn.shake()
            
            let sec = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + sec)
            {
                self.createBtn.layer.backgroundColor = UIColor.systemIndigo.cgColor
                
                self.createBtn.setTitle("Create", for: .normal)
            }
        }
        else
        {
      
            Auth.auth().createUser(withEmail: emailTxt.text!, password: passwordTxt.text!) { (authResult, error) in

                if error != nil
                {
                    let alert = UIAlertController(title: "Error", message: "Email already exists!", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Forgot Password", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)

                }
                else {
                    
                    self.ref?.child("users").child(authResult!.user.uid).child("usersInfo").setValue([
                        "username": self.usernameTxt.text!,
                        "email": self.emailTxt.text!,
                        "password": self.passwordTxt.text!,
                        "uid": authResult!.user.uid
                    ])
                    
                    self.createBtn.layer.backgroundColor = UIColor.systemGreen.cgColor
                    
                    self.createBtn.setTitle("Success!", for: .normal)
                    
                    UserDefaults.standard.set(true, forKey: "checkLoggedIn")
                    UserDefaults.standard.synchronize()
                    
                    let sec = 2.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + sec)
                    {
                        self.transitionToHome()
                    }
                }
            }
        }
    }
    
    func shake(duration: TimeInterval = 0.5, values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")

        // Swift 4.2 and above
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)


        animation.duration = duration // You can set fix duration
        animation.values = values  // You can set fix values here also
        createBtn.layer.add(animation, forKey: "shake")
    }
    
    func transitionToHome() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainHome") as! mainHome

        let navController = UINavigationController(rootViewController: newViewController)
        
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        
        self.present(navController, animated: true, completion: nil)
    }
}
