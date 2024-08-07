//
//  AppCoordinator.swift
//  CarTest
//
//  Created by JayR Atamosa on 8/7/24.
//

import SwiftUI

class AppCoordinator: ObservableObject {
    @Published var contentView: ContentView?

    init() {
        let carViewModel = CarViewModel()
        self.contentView = ContentView(viewModel: carViewModel)
    }
}

