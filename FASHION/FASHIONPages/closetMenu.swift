//
//  closetHome.swift
//  FASHION
//
//  Created by Joshua Alanis on 2020-07-29.
//  Copyright © 2020 Joshua Alanis. All rights reserved.
//

import UIKit
import SceneKit

class closetMenu: UIViewController {
    
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var viewClothes: UIButton!
    @IBOutlet weak var viewOutfits: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Menu"
        
        viewClothes.layer.cornerRadius = 4
        viewClothes.layer.borderWidth = 2.0
        viewClothes.layer.borderColor = UIColor.systemIndigo.cgColor
        viewOutfits.layer.cornerRadius = 4
        viewOutfits.layer.borderWidth = 2.0
        viewOutfits.layer.borderColor = UIColor.systemIndigo.cgColor
        
        //THIS IS FOR THE 3D MODEL
        
        // 1: Load .obj file
        let scene = SCNScene(named: "Max.obj")
                
        // 2: Add camera node
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        // 3: Place camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 20)
                
        // 4: Set camera on scene
        scene?.rootNode.addChildNode(cameraNode)
                
        // 5: Adding light to scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 0, z: 20)
        scene?.rootNode.addChildNode(lightNode)
                
        // 6: Creating and adding ambien light to scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.darkGray
        scene?.rootNode.addChildNode(ambientLightNode)
                
        // If you don't want to fix manually the lights
        //        sceneView.autoenablesDefaultLighting = true
                
        // Allow user to manipulate camera
        sceneView.allowsCameraControl = true
                
        // Show FPS logs and timming
        // sceneView.showsStatistics = true
                
        // Set background color
        sceneView.backgroundColor = UIColor.clear
                
        // Allow user translate image
        sceneView.cameraControlConfiguration.allowsTranslation = false
                
        // Set scene settings
        sceneView.scene = scene

    }
    
    //Toolbar Controls
    @IBAction func homeBtnClicked(_ sender: Any) {
        transitionToHome()
    }
    @IBAction func closetMenuClicked(_ sender: Any) {
        transitionToClosetMenu()
    }
    @IBAction func addPostsClicked(_ sender: Any) {
        transitionToPost()
    }
    @IBAction func weatherClicked(_ sender: Any) {
        transitionToWeather()
    }
    @IBAction func userProfileClicked(_ sender: Any) {
        transitionToProfile()
    }
    
    //Button Inside View Clicks
    @IBAction func clothesClicked(_ sender: Any) {
        transitionToClothes()
    }
    @IBAction func outfitsClicked(_ sender: Any) {
        transitionToOutfits()   
    }
    @IBAction func addShirtClicked(_ sender: Any) {
        addTop()
    }
    
    func addTop() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "addShirt") as! addShirt

        self.navigationController?.pushViewController(newViewController, animated: true)
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
    
    func transitionToClothes() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "myCloset") as! myCloset
        
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func transitionToOutfits() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "outfitsPage") as! outfitsPage
        
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
}
