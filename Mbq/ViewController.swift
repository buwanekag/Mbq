//
//  ViewController.swift
//  Mbq
//
//  Created by Buwaneka Galpoththawela on 4/25/16.
//  Copyright © 2016 Buwaneka Galpoththawela. All rights reserved.
//

    import UIKit
    import CoreData

    class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
        
        var networkManager = NetworkManager.sharedInstance
        var dataManager = DataManager.sharedInstance
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext : NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        var zipcodeArray = [Zipcode]()
        var refreshControl = UIRefreshControl()
        
        @IBOutlet weak var zipcodeTableView :UITableView!
        @IBOutlet weak var addButton: UIBarButtonItem!
        
        
        
        
        
        //MARK:Tableview Method
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return zipcodeArray.count
        }
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell",forIndexPath: indexPath)
            
            cell.textLabel!.text = zipcodeArray[indexPath.row].zipcode
            return cell
        }
            
            func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
                if editingStyle == .Delete {
                    let zipCode = zipcodeArray[indexPath.row] as NSManagedObject
                    managedObjectContext.deleteObject(zipCode)
                    do{
                    try managedObjectContext.save()
                        print("deleted zipcode")
                    }
                    catch {
                        print("Could not delete zip code")
                    }
                    zipcodeArray.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    
                } else if editingStyle == .Insert {

                }
            }
       
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "sendZipcodeSegue" {
                if let destination = segue.destinationViewController as? TemperatureDetailViewController {
                    
                    let path = zipcodeTableView.indexPathForSelectedRow
                    let cell = zipcodeTableView.cellForRowAtIndexPath(path!)
                    destination.zipcodeDisplay = (cell?.textLabel?.text!)!
                }
            }
        }
      
        
        
        //MARK:Core Data Method 
       
        
        func tempAddRecords() {
            let entityDescription :NSEntityDescription! = NSEntityDescription.entityForName("Zipcode", inManagedObjectContext: managedObjectContext)
            let currentZipcode:Zipcode! = Zipcode(entity:entityDescription,insertIntoManagedObjectContext:managedObjectContext)
            currentZipcode.zipcode = "20832"
            currentZipcode.city = "Olney"
            
            appDelegate.saveContext()

        }
        
        func fetchZipcode(keyString: String) -> [Zipcode]? {
            let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "Zipcode")
            fetchRequest.sortDescriptors = [NSSortDescriptor (key: keyString, ascending: true)]
            do {
                let tempArray = try managedObjectContext!.executeFetchRequest(fetchRequest)
                    as! [Zipcode]
                return tempArray
            }catch {
                return nil
            }
            
        }
        
        

        
        
        
        
        //MARK:Life Cycle Methodd

        override func viewDidLoad() {
            super.viewDidLoad()
            //self.tempAddRecords()
            zipcodeArray = fetchZipcode("zipcode")!
     
        }
        
        override func viewDidAppear(animated: Bool) {
            super.viewWillAppear(animated)
            zipcodeArray = fetchZipcode("zipcode")!
            zipcodeTableView.reloadData()
        }

        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }


    }

