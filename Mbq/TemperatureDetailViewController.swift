//
//  TemperatureDetailViewController.swift
//  Mbq
//
//  Created by Buwaneka Galpoththawela on 4/25/16.
//  Copyright © 2016 Buwaneka Galpoththawela. All rights reserved.
//

    import UIKit
    import MapKit
    import CoreLocation
    import Social

    class TemperatureDetailViewController: UIViewController {
        
        var networkManager = NetworkManager.sharedInstance
        var dataManager = DataManager.sharedInstance
        
        
        @IBOutlet weak var zipcodeDisplayLabel: UILabel!
        @IBOutlet weak var temperatureDisplayLabel: UILabel!
        @IBOutlet weak var humidityDisplayLabel:UILabel!
        @IBOutlet weak var degreeSwitch:UISwitch!
        @IBOutlet weak var degreeLabel:UILabel!
        @IBOutlet weak var switchLabel:UILabel!
        @IBOutlet weak var mapView:MKMapView!
        
        var zipcodeDisplay = ""
        var tempAnnotation = MKPointAnnotation()
        
        
        //MARK: Display Method
        
        func newDataReceived() {
            
            let displayForecast = dataManager.currentForecast
            let kelvinTemp = displayForecast.temp
            let doubleTemp = Double(kelvinTemp)!
            let fahrenheitTemp = doubleTemp *  9.0/5.0 - 459.67
            let formatedTemp =  String(format:"%.0f",fahrenheitTemp)
            temperatureDisplayLabel.text = "\(formatedTemp)°"
            
            let formatedHumidity = String(format:"%.0f",Double(displayForecast.humidity)!)
            humidityDisplayLabel.text = "\(formatedHumidity)%"
            
        }
        
       
        
        @IBAction func stateChanged(switchState:UISwitch){
            let displayForecast = dataManager.currentForecast
            let kelvinTemp = displayForecast.temp
            let doubleTemp = Double(kelvinTemp)!
            if switchState.on {
                let fahrenheitTemp = doubleTemp *  9.0/5.0 - 459.67
                let formatedTemp =  String(format:"%.0f",fahrenheitTemp)
                temperatureDisplayLabel.text = "\(formatedTemp)°"
                degreeLabel.text = "F"
                
                
            } else {
                let celsiusTemp = doubleTemp - 273.15
                let formatedTemp =  String(format:"%.0f",celsiusTemp)
                temperatureDisplayLabel.text = "\(formatedTemp)°"
                degreeLabel.text = "C"
                
                
            }

            
        }
        
        
        //MARK:Maps Method
        
        func forwardGeocoding(address: String) {
            CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
                if error != nil {
                    print(error)
                    return
                }
                if placemarks?.count > 0 {
                    let placemark = placemarks?[0]
                    let location = placemark?.location
                    let coordinate = location?.coordinate
                    let weatherLocal = CLLocation(latitude: coordinate!.latitude,longitude: coordinate!.longitude)
                    print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                    let regionRadius: CLLocationDistance = 1000
                    let coordinateRegion = MKCoordinateRegionMakeWithDistance(weatherLocal.coordinate,
                            regionRadius * 2.0, regionRadius * 2.0)
                       self.mapView.setRegion(coordinateRegion, animated: true)
                   self.tempAnnotation.title = "\(self.temperatureDisplayLabel.text!)"
                    self.tempAnnotation.coordinate = weatherLocal.coordinate
                    self.tempAnnotation.subtitle = self.zipcodeDisplay
                    self.mapView.addAnnotation(self.tempAnnotation)
                }
            })
        }
        
        
        //MARK: Social Method
        
        @IBAction func postToTwitterTapped(sender: UIButton){
            if (SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)){
            
                let socialController = SLComposeViewController(forServiceType:SLServiceTypeTwitter)
                self.presentViewController(socialController,animated: true,completion: nil)
            }else{
                let alert = UIAlertController(title: "Twitter Not Available",message: "Sorry Twitter application is not available on phone",preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK",style: .Default,handler: nil))
                self.presentViewController(alert,animated: true,completion: nil)
            
            }
        }
        
        

        
        
        
        //MARK: Life Cycle Method

        override func viewDidLoad() {
            super.viewDidLoad()
            //mapView.delegate = self
            zipcodeDisplayLabel.text = zipcodeDisplay
            dataManager.getDataFromServer(zipcodeDisplay)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TemperatureDetailViewController.newDataReceived), name: "receivedDataFromServer", object: nil)
            forwardGeocoding(zipcodeDisplay)
            
            view.backgroundColor = UIColor.seaBlue()

        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            
        }
        


    }
