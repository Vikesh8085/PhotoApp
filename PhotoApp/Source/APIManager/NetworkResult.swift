//
//  NetworkResult.swift
//  PhotoApp
//
//  Created by Vikesh Prasad on 23/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import Foundation

enum NetworkResult {
    case success([FlickerPhoto])
    case failure(statusCode: HTTPStatusCodes, title: String, subTitle: String)
}

enum HTTPStatusCodes: Int, Equatable {
    case success = 200
    case notFound = 404
    case tooManyRequests = 429
    case unAvailable = 503
}
