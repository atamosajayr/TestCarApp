//
//  Car.swift
//  CarTest
//
//  Created by JayR Atamosa on 8/7/24.
//

import Foundation

struct Car: Identifiable, Codable {
    let id = UUID()
    let make: String
    let model: String
    let customerPrice: Double
    let marketPrice: Double
    let prosList: [String]
    let consList: [String]
    let rating: Int
}

extension Car {
    init(from entity: CarEntity) {
        self.make = entity.make ?? ""
        self.model = entity.model ?? ""
        self.customerPrice = entity.customerPrice
        self.marketPrice = entity.marketPrice
        self.prosList = entity.prosList?.components(separatedBy: ",") ?? []
        self.consList = entity.consList?.components(separatedBy: ",") ?? []
        self.rating = Int(entity.rating)
    }
}

