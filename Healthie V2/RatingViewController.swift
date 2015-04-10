//
//  RatingViewController.swift
//  Healthie V2
//
//  Created by Gabriel Tan on 2/17/15.
//  Copyright (c) 2015 Gabriel Tan. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rateGood(sender: AnyObject) {
    
    
    }

    @IBAction func rateNeutral(sender: AnyObject) {
    
    
    }

    @IBAction func rateBad(sender: AnyObject) {
    
    
    }
    
    func makeRatings() {
        
        // loop through list of images from db
        // keep track of timestamps of images with ratings
        
        
    }

}
