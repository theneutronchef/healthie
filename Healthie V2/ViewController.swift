//
//  ViewController.swift
//  Healthie V2
//
//  Created by Gabriel Tan on 2/9/15.
//  Copyright (c) 2015 Gabriel Tan. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Types of Photographs
    let FaceSelfie = 0
    let BodySelfie = 1
    let FoodPic = 2
    
    @IBOutlet weak var imageView: UIImageView!
    var newMedia: Bool?
    var paths: String?
    var imagePath: String?
    
    let databaseName:NSString = "healthie4.db"
    var databasePath = NSString()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fileManager = NSFileManager.defaultManager()
        
        self.paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as? String
        
//        var filePathToWrite = "\(paths)/SaveFile.png"
        
//        var imageData: NSData = UIImagePNGRepresentation(selectedImage)
        
//        fileManager.createFileAtPath(filePathToWrite, contents: imageData, attributes: nil)
//        let date = NSDate()
//        var formatter = NSDateFormatter();
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
//        let defaultTimeZoneStr = formatter.stringFromDate(date);
        
        // Database Stuff
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] as String
        
        databasePath = docsDir.stringByAppendingPathComponent(databaseName)
        
        if !filemgr.fileExistsAtPath(databasePath) {
            
            let scoreDB = FMDatabase(path: databasePath)
            
            if scoreDB == nil {
                println("Error: \(scoreDB.lastErrorMessage())")
            }
            
            if scoreDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS METADATA (ID INTEGER PRIMARY KEY AUTOINCREMENT, PATH TEXT, TYPE INTEGER, TIMESTAMP TEXT)"
                if !scoreDB.executeStatements(sql_stmt) {
                    println("Error: \(scoreDB.lastErrorMessage())")
                }
                scoreDB.close()
            } else {
                println("Error: \(scoreDB.lastErrorMessage())")
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takeFaceSelfie(sender: AnyObject) {
        useCamera()
        let time = self.getTimeSinceReferenceDate()
        self.imagePath = paths!.stringByAppendingPathComponent(String(time) + ".png")
        self.addToDB(imagePath!, type: FaceSelfie, timestamp: time)
    }

    @IBAction func takeBodySelfie(sender: AnyObject) {
        useCamera()
        let time = self.getTimeSinceReferenceDate()
        self.imagePath = paths!.stringByAppendingPathComponent(String(time) + ".png")
        self.addToDB(imagePath!, type: BodySelfie, timestamp: time)
    }
    
    @IBAction func takeFoodPic(sender: AnyObject) {
        useCamera()
        let time = self.getTimeSinceReferenceDate()
        self.imagePath = paths!.stringByAppendingPathComponent(String(time) + ".png")
        self.addToDB(imagePath!, type: FoodPic, timestamp: time)
    }
    
    @IBAction func viewImages(sender: AnyObject) {
        let image = loadImageFromPath(self.getInfo()!)
        imageView.image = image
    }
    
    @IBAction func openGallery(sender: AnyObject) {
        useCameraRoll()
//        let image = loadImageFromPath(imagePath!)

    }
    
    func useCamera() {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.Camera
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia = true
        }
    }
    
    func useCameraRoll() {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia = false
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as NSString
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType.isEqualToString(kUTTypeImage as NSString) {
            let image = info[UIImagePickerControllerOriginalImage]
                as UIImage
            
            if (newMedia == true) {
                saveImage(image, path: imagePath!)
                UIImageWriteToSavedPhotosAlbum(image, self,
                    "image:didFinishSavingWithError:contextInfo:", nil)
            } else if mediaType.isEqualToString(kUTTypeMovie as NSString) {
                // Code to support video here
            }
            
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveImage (image: UIImage, path: String ) -> Bool{
        
        let pngImageData = UIImagePNGRepresentation(image)
        //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = pngImageData.writeToFile(path, atomically: true)
//        self.addToDB(path)
        return result
        
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
//        self.getInfo()
        if image == nil {
            
            println("missing image at: (path)")
        }
        println("(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }
    
    func addToDB(path: String, type: Int, timestamp: Int) {
        let database = FMDatabase(path: databasePath)
        
        if database.open() {
            let insertSQL = "INSERT INTO METADATA (PATH, TYPE, TIMESTAMP) VALUES ('\(path)', \(type), '\(timestamp)' )"
            let result = database.executeUpdate(insertSQL, withArgumentsInArray: nil)
            
            if !result {
                println("Error: \(database.lastErrorMessage())")
            }
        } else {
            println("Error: \(database.lastErrorMessage())")
        }
    }
    
    func getInfo() -> String? {
        let database = FMDatabase(path: databasePath)
        
        if database.open() {
            let querySQL = "SELECT PATH FROM METADATA ORDER BY TIMESTAMP DESC"
//            let querySQL = "DROP TABLE METADATA"
            let results:FMResultSet? = database.executeQuery(querySQL, withArgumentsInArray: nil)
            if results?.next() == true {
                let path = results?.stringForColumn("path")
                println(path)
                return path
            }
            database.close()
        } else {
            println("Error: \(database.lastErrorMessage())")
        }
        return ""
    }
    
    func getTimeSinceReferenceDate() -> Int {
        return Int(NSDate.timeIntervalSinceReferenceDate())
//        var formatter = NSDateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        return formatter.stringFromDate(date)
//        return date
    }

    
    @IBAction func backToViewController(segue:UIStoryboardSegue) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

