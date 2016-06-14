//
//  DataManager.swift
//  Mbq
//
//  Created by Buwaneka Galpoththawela on 4/25/16.
//  Copyright © 2016 Buwaneka Galpoththawela. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    static let sharedInstance = DataManager()
    
    var baseURLString = "api.openweathermap.org"
    var currentForecast = Forecast()
    
    
    //MARK: Get Data Method
    
    
    func parseForecastData(data:NSData){
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            print("JSON:\(jsonResult)")
            
            let tempDict = jsonResult.objectForKey("main") as! NSDictionary
            self.currentForecast.temp = String(tempDict.objectForKey("temp")!)
            self.currentForecast.humidity = String(tempDict.objectForKey("humidity")!)
            self.currentForecast.temp_max = String(tempDict.objectForKey("temp_max")!)
            self.currentForecast.temp_min = String(tempDict.objectForKey("temp_min")!)
            
            dispatch_async(dispatch_get_main_queue()){
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "receivedDataFromServer", object: nil))
            }
            
            
            
        } catch {
            print("Json error")
        }
        
    }

    
    func getDataFromServer(searchString:String) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        defer{
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
        let url = NSURL(string: "http://\(baseURLString)/data/2.5/weather?zip=\(searchString),us&&APPID=3b535043693316ba125a0513276aa62d")
        
        let urlRequest = NSURLRequest(URL: url!,cachePolicy: .ReloadIgnoringLocalCacheData,timeoutInterval:30.0)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(urlRequest){ (data, response,error) ->  Void in
            if data != nil {
                print("got data")
                self.parseForecastData(data!)
            }else {
                print("No Data")
            }
            
            
        }
        task.resume()
        
    }


}
