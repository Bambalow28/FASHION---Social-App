//
//  makePosts.swift
//  FASHION
//
//  Created by Joshua Alanis on 2020-10-03.
//  Copyright © 2020 Joshua Alanis. All rights reserved.
//
import Foundation
import Firebase
import UIKit

class makePosts: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var captionTxt: UITextField!
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var uploadPhoto: UIButton!
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var postBtn: customButton!
    
    let userID = Auth.auth().currentUser?.uid
    var ref: DatabaseReference!
    private let storage = Storage.storage().reference()

    var urlString = ""
    var usernameInfo = ""
    
    //Makes status bar light
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
    
        userInfo()
        
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibility.isReduceTransparencyEnabled {
            view.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            view.addSubview(blurEffectView)
            view.insertSubview(postView, aboveSubview: blurEffectView)
            
        } else {
            view.backgroundColor = .black
        }
        
        postView.layer.cornerRadius = 10
        postView.layer.masksToBounds = true
        postView.layer.borderWidth = 3.0
        postView.layer.borderColor = UIColor.lightGray.cgColor
        
        uploadPhoto.layer.cornerRadius = 4
        imagePost.layer.borderWidth = 2.0
        imagePost.layer.borderColor = UIColor.gray.cgColor
        
        captionTxt.attributedPlaceholder = NSAttributedString(string: "Enter Caption...",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func makePost(_ sender: Any) {
        
        self.pulsate()

        if ((imagePost != nil) == false) {
            let alert = UIAlertController(title: "Oops!", message: "Photo was not found!", preferredStyle: .alert)
            
            let tryAgain = UIAlertAction(title: "Try Again", style: .default)
            
            alert.addAction(tryAgain)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let sec = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + sec)
            {
                let now = Date()
                
                let formatter = DateFormatter()
                
                formatter.timeZone = TimeZone.current
                
                formatter.dateFormat = "HH:mm"
                
                let dateString = formatter.string(from: now)
                
                //Firebase Saving
                self.ref?.child("posts").child(self.userID!).child(self.captionTxt.text!).setValue([
                    "captionTxt": self.captionTxt.text!,
                    "username": self.usernameInfo,
                    "userID": self.userID!,
                    "timePosted": dateString
                ])
            }
            
            postBtn.setTitle("Posting..", for: .normal)

            let secTwo = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + secTwo)
            {
                self.transitionToHome()
            }
        }
        
    }
    @IBAction func cancelPost(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func userInfo() {
        
        ref?.child("users").child(userID!).child("usersInfo").queryOrderedByKey().observeSingleEvent(of: .value, with: {(snapshot) in
            
            let post = snapshot.value as! NSDictionary
            
            if let actualUsername = post["username"] as? String {
                
                let actualuser = actualUsername
                
                self.usernameInfo.append(actualuser)
                
                
            }
        })
        
    }
    
    @IBAction func uploadPhotoClicked(_ sender: Any) {
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        picker.allowsEditing = true
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else
        {
            print("No image found")
            return
        }
        
        guard let imageData = image.pngData() else{return}
           
        storage.child("images").child(userID!).child("Posts").child(captionTxt.text!).putData(imageData, metadata: nil, completion: { _, error in
                   
            guard error == nil else {
                print("Failed To Upload")
                return
            }
                   
            self.storage.child("images").child(self.userID!).child("Posts").child(self.captionTxt.text!).downloadURL(completion: { url, error in
                       guard let url = url, error == nil else {
                           return
                       }
                    
                    let urlStringCheck = url.absoluteString
                    print("Download URL: \(urlStringCheck)")
                    UserDefaults.standard.set(urlStringCheck, forKey: "url")
                    
                    self.urlString.append(urlStringCheck)
                       
                   })
               })
        
        imagePost.image = image
    }
    
    func transitionToHome() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainHome") as! mainHome
        
        newViewController.modalPresentationStyle = .fullScreen
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
        
        postBtn.layer.add(pulse, forKey: "pulse")
    }
}
