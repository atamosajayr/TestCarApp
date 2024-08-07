//
//  CarViewModel.swift
//  CarTest
//
//  Created by JayR Atamosa on 8/7/24.
//


import Combine
import Foundation
import CoreData

class CarViewModel: ObservableObject {
    @Published var cars: [Car] = []
    @Published var filteredCars: [Car] = []
    @Published var makes: [String] = []
    @Published var models: [String] = []

    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        loadCars()
    }

    func loadCars() {
        let fetchRequest: NSFetchRequest<CarEntity> = CarEntity.fetchRequest()
        
        do {
            let carEntities = try context.fetch(fetchRequest)
            if carEntities.isEmpty {
                if let url = Bundle.main.url(forResource: "car_list", withExtension: "json"),
                   let data = try? Data(contentsOf: url),
                   let cars = try? JSONDecoder().decode([Car].self, from: data) {
                    self.cars = cars
                    saveCarsToCoreData(cars: cars)
                }
            } else {
                self.cars = carEntities.map { Car(from: $0) }
            }
            self.filteredCars = self.cars
            self.makes = Array(Set(self.cars.map { $0.make })).sorted()
            self.models = Array(Set(self.cars.map { $0.model })).sorted()
        } catch {
            print("Failed to fetch cars from Core Data: \(error)")
        }
    }

    func filterCars(byMake make: String?, model: String?) {
        filteredCars = cars.filter { car in
            var makeMatches = true
            var modelMatches = true

            if let make = make, !make.isEmpty {
                if make.uppercased() != "ANY MAKE" {
                    makeMatches = car.make == make
                }
            }

            if let model = model, !model.isEmpty {
                if model.uppercased() != "ANY MODEL" {
                    modelMatches = car.model == model
                }
            }

            return makeMatches && modelMatches
        }
    }

    private func saveCarsToCoreData(cars: [Car]) {
        for car in cars {
            let carEntity = CarEntity(context: context)
            carEntity.make = car.make
            carEntity.model = car.model
            carEntity.customerPrice = car.customerPrice
            carEntity.marketPrice = car.marketPrice
            carEntity.prosList = car.prosList.joined(separator: ",")
            carEntity.consList = car.consList.joined(separator: ",")
            carEntity.rating = Int16(car.rating)
        }
        do {
            try context.save()
        } catch {
            print("Failed to save cars to Core Data: \(error)")
        }
    }
}
