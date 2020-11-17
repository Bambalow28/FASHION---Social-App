//
//  userProfile.swift
//  FASHION
//
//  Created by Joshua Alanis on 2020-09-13.
//  Copyright © 2020 Joshua Alanis. All rights reserved.
//
import Foundation
import UIKit
import FirebaseDatabase
import Firebase

class userProfile: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imageViewEdit: UIImageView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var editBio: UIButton!
    @IBOutlet weak var editProfile: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var username: UITextField!
    
    var closetItems: [String] = []
    var recentPost: [String] = []
    var urlString: URL?
    
    let userID = Auth.auth().currentUser?.uid
    
    var ref: DatabaseReference!
    private let storage = Storage.storage().reference()
    let layout = UICollectionViewLayout()
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.tableView.separatorStyle = .none
        
        collectionView.layer.cornerRadius = 10
        
        imageViewEdit?.layer.cornerRadius = (imageViewEdit.frame.size.width ) / 2
        imageViewEdit.clipsToBounds = true
        imageViewEdit.layer.borderWidth = 1.0
        imageViewEdit.layer.borderColor = UIColor.lightGray.cgColor
        
        profileView.layer.masksToBounds = false
        profileView.layer.cornerRadius = 10
        profileView.layer.shadowColor = UIColor.black.cgColor
        profileView.layer.shadowOpacity = 0.5
        profileView.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        profileView.layer.shadowRadius = 8
        
        collectionView.layer.masksToBounds = false
        
        editProfile.layer.cornerRadius = 10
        editProfile.layer.masksToBounds = false
        editProfile.layer.cornerRadius = 10
        editProfile.layer.shadowColor = UIColor.black.cgColor
        editProfile.layer.shadowOpacity = 0.5
        editProfile.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        editProfile.layer.shadowRadius = 8
        
        editBio.layer.cornerRadius = 10
        editBio.layer.masksToBounds = false
        editBio.layer.cornerRadius = 10
        editBio.layer.shadowColor = UIColor.black.cgColor
        editBio.layer.shadowOpacity = 0.5
        editBio.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        editBio.layer.shadowRadius = 8
        
        getUserInfo()
        getuserPosts()
        getUserItems()
        
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
    
    //TABLEVIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentPost.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentPosts", for: indexPath) as! recentPostsTableViewCell
        
        let posts = recentPost[indexPath.row]
            
        let imageShow: UIImageView = cell.userImages
        let storageRef = self.storage.child("images").child(userID!).child("Posts").child(posts)
        
        //DownloadURL to cache image
        storageRef.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                return
            }
            
            let urlStringCheck = url.absoluteString
            UserDefaults.standard.set(urlStringCheck, forKey: "url")
            
            self.urlString = URL(string: urlStringCheck)
            imageShow.sd_setImage(with: storageRef)
            
        })
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350.0;//Choose your custom row height
    }
    
    //COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return closetItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.height/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storageInfo = self.storage.child("images").child(userID!).child("Items")
        
        storageInfo.listAll(completion: { (result, error) in
            
            if error != nil
            {
                print("Oops! Something went Wrong!")
            }

            for item in result.items
            {
                print(item)
            }

        })

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCollectionViewCell", for: indexPath) as! profileCollectionViewCell
        
        let closet = closetItems[indexPath.row]
            
        let imageShow: UIImageView = cell.items
        let storageRef = self.storage.child("images").child(userID!).child("Items").child(closet)
        
        //DownloadURL to cache image
        storageRef.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                return
            }
            
            let urlStringCheck = url.absoluteString
            UserDefaults.standard.set(urlStringCheck, forKey: "url")
            
            self.urlString = URL(string: urlStringCheck)
            imageShow.sd_setImage(with: storageRef)
            
        })
        
        cell.items.layer.cornerRadius = 10

        return cell
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
    @IBAction func supportClicked(_ sender: Any) {
        transitionToSupport()
    }
    @IBAction func editProfileClicked(_ sender: Any) {
        transitionToEditProfile()
    }
    
    @IBAction func logoutClicked(_ sender: Any)
    {
        UserDefaults.standard.set(false, forKey: "checkLoggedIn")
        UserDefaults.standard.synchronize()
        
        let sec = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + sec)
        {
            self.transitionToLogin()
        }
        
    }
    
    func transitionToLogin() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "loginScreen") as! ViewController
        
        view.window?.rootViewController = newViewController
        view.window?.makeKeyAndVisible()
    }
    
    func getUserInfo()
    {
        ref?.child("users").child(userID!).child("usersInfo").queryOrderedByKey().observeSingleEvent(of: .value, with: {(snapshot) in
            
            let post = snapshot.value as! NSDictionary
            
            if let postUsername = post["username"] as? String {
                
                if let postKey = post["email"] as? String {
                    
                    
                    let showUsername = postUsername
                    let showKey = postKey
                    
                    self.username.text! = showUsername
                    self.email.text! = showKey
                    self.title = self.username.text!
                }
            }
            
        })
    }
    
    func getuserPosts() {
        ref?.child("posts").child(userID!).observe(.childAdded, with: {(snapshot) in
            
            let userPost = snapshot.value as! NSDictionary
            
            if let postTxt = userPost["captionTxt"] as? String {
                
                let profileTxt = postTxt
                self.recentPost.append(profileTxt)
            }
            
        })
    }
    
    func getUserItems() {
        ref?.child("users").child(userID!).child("Items").observeSingleEvent(of: .value, with: {(snapshot) in
            
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                self.closetItems.append(item.key)
            }
        })
    }
    
    fileprivate func checkLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "checkLoggedIn")
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
    
    func transitionToSupport() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "supportBtn") as! supportBtn
        
        newViewController.modalPresentationStyle = .overCurrentContext
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func transitionToClothes() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "viewItem") as! viewItem
        
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func transitionToEditProfile() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editProfileController = storyBoard.instantiateViewController(withIdentifier: "editProfilePage") as! editProfilePage
        
        self.navigationController?.pushViewController(editProfileController, animated: true)
    }
}
