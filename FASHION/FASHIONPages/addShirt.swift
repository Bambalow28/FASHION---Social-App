//
//  addShirt.swift
//  FASHION
//
//  Created by Joshua Alanis on 2020-07-30.
//  Copyright © 2020 Joshua Alanis. All rights reserved.
//
import Foundation
import UIKit
import CoreData
import FirebaseDatabase
import FirebaseStorage
import Firebase
import DropDown

class addShirt: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var lblTopName: UITextField!
    @IBOutlet weak var brandName: UITextField!
    @IBOutlet weak var sizeItem: UITextField!
    @IBOutlet weak var itemLocation: UITextField!
    @IBOutlet weak var photoTaken: UIImageView!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var addBtn: customButton!
    
    var urlString = ""
    let userID = Auth.auth().currentUser?.uid
    let categoryDropdown = DropDown()
    
    var ref: DatabaseReference!
    private let storage = Storage.storage().reference()
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        title = "Add Item"
        
        categoryDropdown.dismissMode = .automatic
        DropDown.appearance().cornerRadius = 10
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.allowsEditing = true
        picker.dismiss(animated: true)

    guard let image = info[.editedImage] as? UIImage else {
        print("No image found")
        return
    }
        
        guard let imageData = image.pngData() else{return}
        
        storage.child("images").child(userID!).child("Items").child(lblTopName.text!).putData(imageData, metadata: nil, completion: { _, error in
            
            guard error == nil else {
                print("Failed To Upload")
                return
            }
            
            self.storage.child("images").child(self.userID!).child("Items").child(self.lblTopName.text!).downloadURL(completion: { url, error in
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
    
    @IBAction func categorySelect(_ sender: UIButton) {
        categoryDropdown.dataSource = ["Top", "Bottoms", "Shoes", "Accessories"]//4
        categoryDropdown.anchorView = sender as AnchorView //5
        categoryDropdown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height) //6
        categoryDropdown.show() //7
        categoryDropdown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                (sender as AnyObject).setTitle(item, for: .normal) //9
            }
    }
    
    @IBAction func addClicked(_ sender: Any)
    {
        if lblTopName.text == ""
        {
            self.addBtn.setTitle("Error!", for: .normal)
            self.addBtn.layer.backgroundColor = UIColor.systemRed.cgColor
            self.addBtn.shake()
            
            let sec = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
                self.addBtn.layer.backgroundColor = UIColor.systemIndigo.cgColor
                self.addBtn.setTitle("ADD", for: .normal)
            }
        }
        else if brandName.text == ""
        {
            self.addBtn.setTitle("Error!", for: .normal)
            self.addBtn.layer.backgroundColor = UIColor.systemRed.cgColor
            self.addBtn.shake()
            
            let sec = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
                self.addBtn.layer.backgroundColor = UIColor.systemIndigo.cgColor
                self.addBtn.setTitle("ADD", for: .normal)
            }
        }
        else if sizeItem.text == ""
        {
            self.addBtn.setTitle("Error!", for: .normal)
            self.addBtn.layer.backgroundColor = UIColor.systemRed.cgColor
            self.addBtn.shake()
            
            let sec = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
                self.addBtn.layer.backgroundColor = UIColor.systemIndigo.cgColor
                self.addBtn.setTitle("ADD", for: .normal)
            }
        }
        else if itemLocation.text == ""
        {
            self.addBtn.setTitle("Error!", for: .normal)
            self.addBtn.layer.backgroundColor = UIColor.systemRed.cgColor
            self.addBtn.shake()
            
            let sec = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
                self.addBtn.layer.backgroundColor = UIColor.systemIndigo.cgColor
                self.addBtn.setTitle("ADD", for: .normal)
            }
        }
        else
        {
            let categorySelected = categoryBtn.currentTitle!
            
            //Firebase Saving
            self.ref?.child("users").child(self.userID!).child("Items").child(self.lblTopName.text!).setValue([
                "brandName": self.brandName.text!,
                "itemSize": self.sizeItem.text!,
                "itemLocation": self.itemLocation.text!,
                "imageURL": self.urlString,
                "category": categorySelected
            ])
            self.addBtn.layer.backgroundColor = UIColor.systemGreen.cgColor
            self.addBtn.setTitle("Saved!", for: .normal)
            
            let sec = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + sec)
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
    @IBAction func backToRootView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        
        let navController = UINavigationController(rootViewController: newViewController)
        
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func transitionToClosetMenu() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "closetMenu") as! closetMenu
        
        let navController = UINavigationController(rootViewController: newViewController)
        
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func transitionToWeather() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "weatherHome") as! weatherHome
        
        let navController = UINavigationController(rootViewController: newViewController)
        
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func transitionToProfile() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "userProfile") as! userProfile
        
        let navController = UINavigationController(rootViewController: newViewController)
        
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        
        self.present(navController, animated: true, completion: nil)
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
        
        let navController = UINavigationController(rootViewController: newViewController)
        
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        
        self.present(navController, animated: true, completion: nil)
    }
}




