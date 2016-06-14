//
//  DetailViewController.swift
//  Mbq
//
//  Created by Buwaneka Galpoththawela on 4/25/16.
//  Copyright © 2016 Buwaneka Galpoththawela. All rights reserved.
//

    import UIKit
    import CoreData

    class DetailViewController: UIViewController,UITextFieldDelegate {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext : NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

        @IBOutlet weak var zipcodeLabel:UILabel!
        @IBOutlet weak var cityNameLabel:UILabel!
        @IBOutlet weak var zipcodeTextField:UITextField!
        @IBOutlet weak var cityNameTextField:UITextField!
        
        var currentZipcode :Zipcode?
        let zipcodeLength = 5
        
        
        //MARK: Interactive Method
        
        @IBAction func saveButtonPressed(sender:UIBarButtonItem){
            if currentZipcode == nil {
                let entityDescription :NSEntityDescription! = NSEntityDescription.entityForName("Zipcode", inManagedObjectContext: managedObjectContext)
                currentZipcode = Zipcode(entity:entityDescription,insertIntoManagedObjectContext:managedObjectContext)
            }
            
            currentZipcode!.city = cityNameTextField.text
            currentZipcode!.zipcode = zipcodeTextField.text
            appDelegate.saveContext()
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
        func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
            
            guard let text = zipcodeTextField.text else { return true }
            
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= zipcodeLength
        }


    
    
    
    //MARK: Life Cycle Method
    
        override func viewDidLoad() {
            super.viewDidLoad()
            zipcodeTextField.delegate = self
            zipcodeTextField.keyboardType = .NumberPad
            view.backgroundColor = UIColor.seaBlue()
            
            
            }

           
            
            
            
        

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
           
        }
    

}
