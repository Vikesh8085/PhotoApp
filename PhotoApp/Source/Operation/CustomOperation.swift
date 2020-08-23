//
//  CustomOperation.swift
//  PhotoApp
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import Foundation

class CustomOperation: Operation {
    
    private let lockedQueue = DispatchQueue(label: "com.photoApp.CustomOperation",  attributes: .concurrent)
    override open var isAsynchronous: Bool {
        return true
    }

    private var _isExecuting: Bool = true
    override open private(set) var isExecuting: Bool {
        get {
            return lockedQueue.sync { () -> Bool in
                return _isExecuting
            }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            lockedQueue.sync(flags: [.barrier]) {
                _isExecuting = newValue
            }
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _isFinished: Bool = true
    override open private(set) var isFinished: Bool {
        get {
            return lockedQueue.sync { () -> Bool in
                return _isFinished
            }
        }
        set {
            willChangeValue(forKey: "isFinished")
            lockedQueue.sync(flags: [.barrier]) {
                _isFinished = newValue
            }
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override open func start() {
        guard !isCancelled else {
            finish()
            return
        }
        isFinished = false
        isExecuting = true
        main()
    }
    
    override open func main() {
    }
    
    open func finish() {
        isExecuting = false
        isFinished = true
    }

}
