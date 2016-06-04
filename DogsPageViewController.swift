//
//  DogsPageViewController.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 2/4/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit

class DogsPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    @IBOutlet weak var Open: UIBarButtonItem!
    var index = 0
    var identifiers: NSArray = ["BarChartController", "PieChartController", "LineChartController"]
    override func viewDidLoad() {
        super.viewDidLoad()
        Open.image = UIImage(named: "Open")
        Open.title = ""
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Do any additional setup after loading the view.
        self.dataSource = self
        self.delegate = self
        
        let startingViewController = self.viewControllerAtIndex(self.index)
        let viewControllers: NSArray = [startingViewController]
        self.setViewControllers(viewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        
        
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController! {
        
        //first view controller = firstViewControllers navigation controller
        if index == 0 {
            
            return self.storyboard!.instantiateViewControllerWithIdentifier("BarChartController") as! BarChartController
            
        }
        
        //second view controller = secondViewController's navigation controller
        if index == 1 {
            
            return self.storyboard!.instantiateViewControllerWithIdentifier("PieChartController") 
        }
        
        return nil
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let identifier = viewController.restorationIdentifier
        let index = self.identifiers.indexOfObject(identifier!)
        
        //if the index is the end of the array, return nil since we dont want a view controller after the last one
        if index == identifiers.count - 1 {
            
            return nil
        }
        
        //increment the index to get the viewController after the current index
        self.index = self.index + 1
        return self.viewControllerAtIndex(self.index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let identifier = viewController.restorationIdentifier
        let index = self.identifiers.indexOfObject(identifier!)
        
        //if the index is 0, return nil since we dont want a view controller before the first one
        if index == 0 {
            
            return nil
        }
        
        //decrement the index to get the viewController before the current one
        self.index = self.index - 1
        return self.viewControllerAtIndex(self.index)
        
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.identifiers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    
/*
    var doggies: dog?
    let coolColor  = UILabel()
    let DogNameLost = UILabel()
    let DogImageLost = UIImageView()
    var shareButton = UIButton(type: .System)
    var index = 0
    var identifiers: NSArray = ["LostViewController", "CalendarViewController"]
    override func viewDidLoad() {
        super.viewDidLoad()
           print(doggies)
        DogNameLost.text = doggies!.name
        DogImageLost.image = doggies?.photo // Do any additional setup after loading the view.
        self.dataSource = self
        self.delegate = self
        
        let startingViewController = self.viewControllerAtIndex(self.index)
        let viewControllers: NSArray = [startingViewController]
        self.setViewControllers(viewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        
        
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController! {
        
        //first view controller = firstViewControllers navigation controller
        if index == 0 {
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("LostViewController") as! LostViewController
            let video = self.doggies
            vc.doggie = video
            //print(vc.doggie?.name)
            //print(video?.name)
            return self.storyboard!.instantiateViewControllerWithIdentifier("LostViewController")
            
        }
        
        //second view controller = secondViewController's navigation controller
        if index == 1 {
            
            return self.storyboard!.instantiateViewControllerWithIdentifier("CalendarViewController") as! UITableViewController
        }
        
        return nil
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let identifier = viewController.restorationIdentifier
        let index = self.identifiers.indexOfObject(identifier!)
        
        //if the index is the end of the array, return nil since we dont want a view controller after the last one
        if index == identifiers.count - 1 {
            
            return nil
        }
        
        //increment the index to get the viewController after the current index
        self.index = self.index + 1
        return self.viewControllerAtIndex(self.index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let identifier = viewController.restorationIdentifier
        let index = self.identifiers.indexOfObject(identifier!)
        
        //if the index is 0, return nil since we dont want a view controller before the first one
        if index == 0 {
            
            return nil
        }
        
        //decrement the index to get the viewController before the current one
        self.index = self.index - 1
        return self.viewControllerAtIndex(self.index)
        
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.identifiers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }*/

    

}


