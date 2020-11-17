//
//  viewItem.swift
//  FASHION
//
//  Created by Joshua Alanis on 2020-08-22.
//  Copyright © 2020 Joshua Alanis. All rights reserved.
//
import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
import Firebase

class viewItem: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var itemCategoryName: UILabel!
    @IBOutlet weak var brandName: UITextField!
    @IBOutlet weak var itemSize: UITextField!
    @IBOutlet weak var itemLocation: UITextField!
    @IBOutlet weak var updateBtn: customButton!
    @IBOutlet weak var photoTaken: UIImageView!
    @IBOutlet weak var lblTest: UILabel!
    
    private let storage = Storage.storage().reference()
    var ref: DatabaseReference!
    var urlString: URL!
    var newUrlString = ""
    let userID = Auth.auth().currentUser?.uid
    
    override var preferredStatusBarStyle: UIStatusBarStyle
       {
           return .lightContent
       }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        photoTaken.layer.cornerRadius = 4
        photoTaken.layer.borderWidth = 1.0
        photoTaken.layer.borderColor = UIColor.darkGray.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
 
        let secOne = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + secOne)
        {
            self.retrieveitemName()
        }
        
        let secTwo = 0.4
        DispatchQueue.main.asyncAfter(deadline: .now() + secTwo)
        {
            self.retrieveItemInfo()
        }
        
        let secThree = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + secThree)
        {
            self.retrieveImage()
        }
        
        let secFour = 0.9
        DispatchQueue.main.asyncAfter(deadline: .now() + secFour)
        {
            self.resetInfo()
        }

    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
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
    
    func textFieldShouldReturn(_textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Toolbar Controls
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
    
    
    @IBAction func updateBtnClicked(_ sender: Any) {
        
        let updateChanges = itemCategoryName.text!

        guard let key = ref?.child("users").child(userID!).child("Items").child(updateChanges).key else { return }
        
        let post = ["brandName": self.brandName.text!,
                    "itemSize": self.itemSize.text!,
                    "itemLocation": self.itemLocation.text!]
        
        let updateNew = ["users/\(userID!)/Items/\(key)": post]
        
        ref.updateChildValues(updateNew)
        
        self.updateBtn.setTitle("Updated!", for: .normal)
        
        let sec = 1.5
        DispatchQueue.main.asyncAfter(deadline: .now() + sec)
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func uploadPhotoClicked(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
            
        func photoUpload()
        {
            guard let imageData = image.pngData() else{return}
            
            storage.child("images").child(userID!).child("Items").child(itemCategoryName.text!).putData(imageData, metadata: nil, completion: { _, error in
                
                guard error == nil else {
                    print("Failed To Upload")
                    return
                }
                
                self.storage.child("images").child(self.userID!).child("Items").child(self.itemCategoryName.text!).downloadURL(completion: { url, error in
                    guard let url = url, error == nil else {
                        return
                    }
                    
                    let urlStringCheck = url.absoluteString
                    print("Download URL: \(urlStringCheck)")
                    UserDefaults.standard.set(urlStringCheck, forKey: "url")
                    
                    self.newUrlString.append(urlStringCheck)
                    
                })
            })
        }
            photoTaken.image = image
    }
    
    func textAnimations() {
        UIView.transition(with: self.itemCategoryName,
                      duration: 0.25,
                       options: .transitionCrossDissolve,
                    animations: { [weak self] in
                        self?.itemCategoryName.text = (arc4random() % 2 == 0) ? "" : ""
                 }, completion: nil) 
    }
    
    func retrieveitemName() {
        
        ref?.child("users").child(userID!).child("itemSelected").observe(.childAdded, with: {(snapshot) in
            
            let post = snapshot.value as? String
            
            if let actualBrand = post {
            
                self.textAnimations()
                self.itemCategoryName.text! = actualBrand
                self.lblTest.text! = actualBrand
                
            }
  
        })
        
    }
    
    func retrieveItemInfo() {
        
        let itemsID = lblTest.text!

        ref?.child("users").child(userID!).child("Items").child(itemsID).queryOrderedByKey().observeSingleEvent(of: .value, with: {(snapshot) in
            
            let post = snapshot.value as! NSDictionary
            
            if let actualBrand = post["brandName"] as? String {
                
                if let actualSize = post["itemSize"] as? String {
                    
                    if let actualLocation = post["itemLocation"] as? String {
                            
                            let actualBrandName = actualBrand
                            let actualitemSize = actualSize
                            let actualitemLocation = actualLocation
                            
                            self.brandName.text! = actualBrandName
                            self.itemSize.text! = actualitemSize
                            self.itemLocation.text! = actualitemLocation
                        
                    }
                }
                
            }
  
        })
    }
    
    func resetInfo() {
        
        let resetValue = ""
        
        ref.child("users").child(userID!).child("itemSelected").setValue([
            "itemName": resetValue
        ])
    }
    
    func retrieveImage() {
        
        let itemImageName = lblTest.text!
        let imageShow: UIImageView = photoTaken
        let placeholderImage = UIImage(named: "closet.jpg")
        
        let storageRef = self.storage.child("images").child(userID!).child("Items").child(itemImageName)
        
        storageRef.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                return
            }
            
            let urlStringCheck = url.absoluteString
            UserDefaults.standard.set(urlStringCheck, forKey: "url")
            
            self.urlString = URL(string: urlStringCheck)
            imageShow.sd_setImage(with: storageRef, placeholderImage: placeholderImage)
        })
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
}
