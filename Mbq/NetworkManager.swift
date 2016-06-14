//
//  NetworkManager.swift
//  Mbq
//
//  Created by Buwaneka Galpoththawela on 4/25/16.
//  Copyright © 2016 Buwaneka Galpoththawela. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    
    static let sharedInstance = NetworkManager()
    var serverReach: Reachability?
    var serverAvailable = false
    
    func reachabilityChanged(note: NSNotification) {
        let reach = note.object as! Reachability
        serverAvailable = !(reach.currentReachabilityStatus().rawValue == NotReachable.rawValue)
        if serverAvailable {
            print("changed: server available")
        }else {
            print("changed: server not available")
        }
    }
    
    override init() {
        super.init()
        print("Starting Network Manager")
        let dataManager = DataManager.sharedInstance
        serverReach = Reachability(hostName: dataManager.baseURLString)
        serverReach?.startNotifier()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NetworkManager.reachabilityChanged(_:)), name: kReachabilityChangedNotification, object: nil)
    }

    

}
