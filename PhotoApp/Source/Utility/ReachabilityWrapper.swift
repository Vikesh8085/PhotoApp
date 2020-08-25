//
//  ReachabilityWrapper.swift
//  PhotoApp
//
//  Created by Vikesh Prasad on 25/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import Reachability

/**
   This is Reachability Wrapper
*/
class ReachabilityWrapper {
   static let shared = ReachabilityWrapper()
   private var reachability: Reachability?

    // MARK: - Initialiser
    init() {
        initiateReachalibity()
    }
   
    /**
       initiateReachalibity
    */
   fileprivate func initiateReachalibity() {
        do {
            try reachability = Reachability()
            try reachability!.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
    /**
       isNetworkAvailable
    */
    func isNetworkAvailable() -> Bool {
        return reachability?.connection != .unavailable
    }
}
