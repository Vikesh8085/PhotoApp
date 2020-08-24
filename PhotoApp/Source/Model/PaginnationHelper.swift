//
//  PaginnationHelper.swift
//  PhotoApp
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import Foundation

public class PaginnationHelper {

    // MARK: Properties
    public var totalPage: Int?
    public var numberOfAvaiablePhoto: Int32?
    public var currentSize: Int = 20
    public var currentPage: Int?

    init(totalPages: Int, total: Int32, currentPage: Int) {
        self.totalPage = totalPages
        self.numberOfAvaiablePhoto = total
        self.currentPage = currentPage
    }
}
