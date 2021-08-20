//
//  ApiData.swift
//  Dashboard
//
//  Created by Gowtham S on 20/07/21.
//

import Foundation

struct ApiData: Codable {
    let status: String
    let data: Datas
//
    
}

struct Workers: Codable {
    let worker: String
}

struct CurrentStatistics: Codable {
    let unpaid: Int
    let unconfirmed: Int
    let currentHashrate: Double
    let validShares: Int
}

struct Statistics: Codable {
    let currentHashrate: Double
}

struct Datas: Codable {
    let workers: [Workers]
    let currentStatistics: CurrentStatistics
    let statistics: [Statistics]
}
