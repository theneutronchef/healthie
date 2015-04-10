//
//  SurveyViewController.swift
//  Healthie V2
//
//  Created by Gabriel Tan on 2/17/15.
//  Copyright (c) 2015 Gabriel Tan. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController {
    
    let happinessSurvey: Int = 0
    
    let databaseName:NSString = "healthie41.db"
    var databasePath = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
                let sql_stmt = "CREATE TABLE IF NOT EXISTS SURVEY (ID INTEGER PRIMARY KEY AUTOINCREMENT, TYPE INTEGER, VALUE INTEGER, TIMESTAMP TEXT)"
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
    
    @IBAction func happinessOne(sender: AnyObject) {
        let time = self.getTimeSinceReferenceDate()
        addToDB(happinessSurvey, value: 1, timestamp: time)
    }
    
    @IBAction func happinessTwo(sender: AnyObject) {
        let time = self.getTimeSinceReferenceDate()
        addToDB(happinessSurvey, value: 2, timestamp: time)
    }

    @IBAction func happinessThree(sender: AnyObject) {
        let time = self.getTimeSinceReferenceDate()
        addToDB(happinessSurvey, value: 3, timestamp: time)
    }
    
    @IBAction func happinessFour(sender: AnyObject) {
        let time = self.getTimeSinceReferenceDate()
        addToDB(happinessSurvey, value: 4, timestamp: time)
    }
    
    @IBAction func happinessFive(sender: AnyObject) {
        let time = self.getTimeSinceReferenceDate()
        addToDB(happinessSurvey, value: 5, timestamp: time)
    }
    
    func addToDB(type: Int, value: Int, timestamp: Int) {
        let database = FMDatabase(path: databasePath)
        
        if database.open() {
            let insertSQL = "INSERT INTO SURVEY (TYPE, VALUE, TIMESTAMP) VALUES ('\(type)', \(value), '\(timestamp)' )"
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
            let querySQL = "SELECT HAPPINESS FROM SURVEY ORDER BY TIMESTAMP DESC"
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


}
