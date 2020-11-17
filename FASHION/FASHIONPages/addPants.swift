//
//  addPants.swift
//  FASHION
//
//  Created by Joshua Alanis on 2020-08-04.
//  Copyright © 2020 Joshua Alanis. All rights reserved.
//
import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
import Firebase

class addPants: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var lblBotName: UITextField!
    @IBOutlet weak var brandName: UITextField!
    @IBOutlet weak var sizeItem: UITextField!
    @IBOutlet weak var itemLocation: UITextField!
    @IBOutlet weak var photoTaken: UIImageView!
    @IBOutlet weak var addBtn: customButton!
    
    var urlString = ""
    
    var ref: DatabaseReference!
    private let storage = Storage.storage().reference()
    
    override var preferredStatusBarStyle: UIStatusBarStyle
       {
           return .lightContent
       }

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
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
    
    @IBAction func uploadPhotoClicked(_ sender: Any)
    {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
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
           
        storage.child("images").child(lblBotName.text!).putData(imageData, metadata: nil, completion: { _, error in
                   
                   guard error == nil else {
                       print("Failed To Upload")
                       return
                   }
                   
                self.storage.child("images").child(self.lblBotName.text!).downloadURL(completion: { url, error in
                       guard let url = url, error == nil else {
                           return
                       }
                    
                    let urlStringCheck = url.absoluteString
                    print("Download URL: \(urlStringCheck)")
                    UserDefaults.standard.set(urlStringCheck, forKey: "url")
                    
                    self.urlString.append(urlStringCheck)
                       
                   })
               })
        
        photoTaken.image = image
    }
    
    @IBAction func addClicked(_ sender: Any)
    {
        if lblBotName.text == ""
        {
            self.addBtn.setTitle("Error!", for: .normal)
            self.addBtn.shake()
            
            let sec = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + sec)
            {
                self.addBtn.setTitle("ADD", for: .normal)
            }
        }
        else if brandName.text == ""
        {
            self.addBtn.setTitle("Error!", for: .normal)
            self.addBtn.shake()
            
            let sec = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + sec)
            {
                self.addBtn.setTitle("ADD", for: .normal)
            }
        }
        else if sizeItem.text == ""
        {
            self.addBtn.setTitle("Error!", for: .normal)
            self.addBtn.shake()
            
            let sec = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + sec)
            {
                self.addBtn.setTitle("ADD", for: .normal)
            }
        }
        else if itemLocation.text == ""
        {
            self.addBtn.setTitle("Error!", for: .normal)
            self.addBtn.shake()
            
            let sec = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + sec)
            {
                self.addBtn.setTitle("Error!", for: .normal)
            }
        }
        else
        {
            let userID = Auth.auth().currentUser?.uid
            
            let sec = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + sec)
            {
                //Firebase Saving
                self.ref?.child("users").child(userID!).child("Items").child(self.lblBotName.text!).setValue([
                    "brandName": self.brandName.text!,
                    "itemSize": self.sizeItem.text!,
                    "itemLocation": self.itemLocation.text!,
                    "imageURL": self.urlString
                ])
            }
            
            
            self.addBtn.setTitle("Saved!", for: .normal)
            
            let secTwo = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + secTwo)
            {
                self.transitionToCloset()
            }
            
            
        }
    }
    
    @IBAction func homeBtnClicked(_ sender: Any) {
        transitionToHome()
    }
    @IBAction func closetMenuClicked(_ sender: Any) {
        transitionToClosetMenu()
    }
    @IBAction func addPostClicked(_ sender: Any) {
        transitionToPost()
    }
    @IBAction func weatherClicked(_ sender: Any) {
        transitionToWeather()
    }
    @IBAction func userProfileClicked(_ sender: Any) {
        transitionToProfile()
    }
    
    func shake(duration: TimeInterval = 0.5, values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")

        // Swift 4.2 and above
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)


        animation.duration = duration // You can set fix duration
        animation.values = values  // You can set fix values here also
        addBtn.layer.add(animation, forKey: "shake")
    }
    
    func transitionToHome() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainHome") as! mainHome
        
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func transitionToClosetMenu() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "closetMenu") as! closetMenu
        
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func transitionToWeather() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "weatherHome") as! weatherHome
        
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func transitionToProfile() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "userProfile") as! userProfile
        
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func transitionToPost() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "makePosts") as! makePosts
        
        newViewController.modalPresentationStyle = .overCurrentContext
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func transitionToCloset() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "myCloset") as! myCloset
        
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
}

