//
//  myCloset.swift
//  FASHION
//
//  Created by Joshua Alanis on 2020-08-12.
//  Copyright © 2020 Joshua Alanis. All rights reserved.
//
import Foundation
import UIKit
import CoreData
import FirebaseDatabase
import FirebaseStorage
import FirebaseUI
import Firebase

class myCloset: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalItemsCount: UILabel!
    
    var items = [String]()
    var fetchedImage = [UIImage]()
    var imageString = [String]()
    var urlString: URL?
    
    let userID = Auth.auth().currentUser?.uid

    var ref: DatabaseReference!
    private let storage = Storage.storage().reference()
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Closet"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        ref = Database.database().reference()
        
        load()
        
        self.tableView.separatorStyle = .none
        
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
    @IBAction func addClicked(_ sender: Any) {
        transitionToAdd()
    }
    @IBAction func popToRoot(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "closetItem") as! CustomTableViewCell
        
        cell.cellVIew.layer.cornerRadius = 4
        cell.itemName.textColor = UIColor.white
        
        cell.cellVIew.layer.shadowColor = UIColor.black.cgColor
        cell.cellVIew.layer.shadowOpacity = 1
        cell.cellVIew.layer.shadowOffset = .zero
        cell.cellVIew.layer.shadowRadius = 2
        
        cell.itemImage.layer.cornerRadius =  cell.itemImage.frame.height/2
        
        addItem(cell, at: indexPath)
        
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(viewItemBtn(_:)), for: .touchUpInside)
        
        let itemImageName = items[indexPath.row]
        let imageShow: UIImageView = cell.itemImage
        let placeholderImage = UIImage(named: "closet.jpg")
        
        let storageRef = self.storage.child("images").child(userID!).child("Items").child(itemImageName)
        
        //DownloadURL to cache image
        storageRef.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                return
            }

            let urlStringCheck = url.absoluteString
            UserDefaults.standard.set(urlStringCheck, forKey: "url")

            self.urlString = URL(string: urlStringCheck)
            imageShow.sd_setImage(with: storageRef, placeholderImage: placeholderImage)
        })
        
        return cell
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        self.tableView.reloadData()
    }
    
    func addItem(_ cell: CustomTableViewCell, at indexPath: IndexPath)
    {
        cell.itemName?.text = items[indexPath.row]
        
        let itemCheck = items.count
        
        totalItemsCount.text? = "Total Items: \(itemCheck)"
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if(editingStyle == .delete){
            
            let itemsID = items[indexPath.row]
            
            ref.child("users").child(userID!).child("Items").child(itemsID).removeValue()
            self.items.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let desertRef = storage.child("images").child(itemsID)
            
            // Delete the file
            desertRef.delete { error in
                if error != nil {
                    print("Oops! Something Went Wrong!")
                } else {
                    print("Success! Photo Deleted!")
                }
            }
            
            self.tableView.reloadData()
            
        }
    }

    func load(){
        
        //Retrieve Data from DB
        ref?.child("users").child(userID!).child("Items").observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children.allObjects as! [DataSnapshot]
            {
                self.items.append(child.key)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            }
        })
    }
    
    @objc func viewItemBtn(_ sender: UIButton) {
        
        let itemsID = items[sender.tag]
        
        ref.child("users").child(userID!).child("itemSelected").setValue([
            "itemName": itemsID
        ])

        DispatchQueue.main.async
        {
            self.transitionToViewItem()
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
    
    func transitionToAdd() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "addShirt") as! addShirt
        
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func transitionToViewItem() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "viewItem") as! viewItem
        
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
}

extension myCloset: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                addItem(cell as! CustomTableViewCell, at: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        @unknown default:
            print("Oops!")
        }
    }
}


