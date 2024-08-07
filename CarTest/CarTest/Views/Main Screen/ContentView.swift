//
//  ContentView.swift
//  CarTest
//
//  Created by JayR Atamosa on 8/7/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: CarViewModel
    @State private var expandedIndex: Int? = 0
    @State private var selectedMake: String = "Any make" {
        didSet {
            viewModel.filterCars(byMake: selectedMake, model: selectedModel)
        }
    }
    @State private var selectedModel: String = "Any model" {
        didSet {
            viewModel.filterCars(byMake: selectedMake, model: selectedModel)
        }
    }
    
    init(viewModel: CarViewModel) {
        let coloredNavAppearance = UINavigationBarAppearance()
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = UIColor(named: "orange")
        coloredNavAppearance.titleTextAttributes = [.font: UIFont(name: "HelveticaNeue-Bold", size: 25)!, .foregroundColor: UIColor.white]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView()
                    .frame(height: 200)
                    .padding(.top, 0)
                    .background(Color.black)
                
                FilterView(
                    viewModel: viewModel, selectedMake: $selectedMake,
                    selectedModel: $selectedModel,
                    makes: Array(Set(viewModel.cars.map { $0.make })),
                    models: Array(Set(viewModel.cars.map { $0.model }))
                )
                .frame(height: 200)
                .padding(.top, -10)
                .padding(.horizontal, 10)
                
                ScrollView {
                    CarListView(expandedIndex: $expandedIndex, cars: viewModel.filteredCars)
                        .padding(.top, 10)
                }
                .frame(maxHeight: .infinity)
                .padding(.top, -30)
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .navigationBarTitle("GUIDOMIA", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    print("Button tapped")
                }) {
                    Image("menu")
                        .renderingMode(.template)
                        .colorMultiply(.white)
                        .foregroundColor(.white)
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            expandedIndex = 0
        }
    }
}

import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack {
            Image(uiImage: UIImage(named: "Tacoma")!)
                .resizable()
                .scaledToFill()
            
            Text("Tacoma 2021")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(radius: 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
                .padding(.top, -100)
            
            Text("Get yours now")
                .font(.title2)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
                .padding(.top, -85)
        }
        .background(Color.white)
    }
}

struct FilterView: View {
    @ObservedObject var viewModel: CarViewModel
    @Binding var selectedMake: String
    @Binding var selectedModel: String
    
    var makes: [String]
    var models: [String]
    
    var body: some View {
        VStack {
            HStack {
                Text("Filters")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(.bottom, 5)
                Spacer()
            }
            .padding(.horizontal, 10)
            VStack {
                ZStack {
                    HStack {
                        Text("\(selectedMake)")
                            .font(.subheadline)
                            .foregroundColor(Color("darkGray"))
                            .background(.white)
                            .onChange(of: selectedMake) {
                                viewModel.filterCars(byMake: selectedMake, model: selectedModel)
                            }
                        Spacer()
                    }
                    
                    Picker("Make", selection: $selectedMake) {
                        Text("Any make").tag("Any make")
                        ForEach(makes, id: \.self) { make in
                            Text(make).tag(make)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal)
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(8)
                    .opacity(0.025)
                }
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity)
                .frame(height: 30)
                .background(.white)
                .cornerRadius(8)
                ZStack {
                    HStack {
                        Text("\(selectedModel)")
                            .font(.subheadline)
                            .foregroundColor(Color("darkGray"))
                            .background(.white)
                            .onChange(of: selectedModel) {
                                viewModel.filterCars(byMake: selectedMake, model: selectedModel)
                            }
                        Spacer()
                    }
                    Picker("Model", selection: $selectedModel) {
                        Text("Any model").tag("Any model")
                        ForEach(models, id: \.self) { model in
                            Text(model).tag(model)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal, 10)
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(8)
                    .opacity(0.025)
                }
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity)
                .frame(height: 30)
                .background(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color("darkGray"))
        .cornerRadius(10)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct CarListView: View {
    @Binding var expandedIndex: Int?
    var cars: [Car]
    
    var body: some View {
        ForEach(cars.indices, id: \.self) { index in
            VStack {
                VStack {
                    HStack {
                        Image("\(cars[index].model.lowercased())")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding(.leading, 20)
                            .padding(.top, 2)
                        VStack(alignment: .leading) {
                            if countWords(in: "\(cars[index].make) \(cars[index].model)") > 2 {
                                Text(cars[index].model)
                                    .foregroundStyle(.black.opacity(0.45))
                                    .font(.headline)
                            } else {
                                Text("\(cars[index].make) \(cars[index].model)")
                                    .foregroundStyle(.black.opacity(0.45))
                                    .font(.headline)
                            }
                            Text("Price: \(cars[index].customerPrice)")
                                .foregroundStyle(.black.opacity(0.45))
                                .font(.subheadline)
                            HStack {
                                ForEach(0..<cars[index].rating, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(Color("orange"))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                        .padding(.top, 2)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        withAnimation {
                            expandedIndex = expandedIndex == index ? nil : index
                        }
                    }
                    
                    if expandedIndex == index {
                        VStack(alignment: .leading) {
                            Text("Pros:")
                                .foregroundStyle(.black.opacity(0.45))
                                .font(.headline)
                            ForEach(cars[index].prosList, id: \.self) { pro in
                                if !pro.isEmpty {
                                    HStack {
                                        Text("•")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color("orange"))
                                        Text("\(pro)")
                                            .padding(.leading, 2)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                }
                            }
                            Text("Cons:")
                                .foregroundStyle(.black.opacity(0.45))
                                .font(.headline)
                                .padding(.top, 4)
                            ForEach(cars[index].consList, id: \.self) { con in
                                if !con.isEmpty {
                                    HStack {
                                        Text("•")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color("orange"))
                                        Text("\(con)")
                                            .padding(.leading, 2)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 8)
                        .padding(.leading, 35)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color("lightGray"))
                Rectangle()
                    .fill(Color("orange"))
                    .frame(height: 4)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .padding(.top, 4)
            }
        }
    }
}


// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let carViewModel = CarViewModel()
        
        // Mock data for preview
        carViewModel.cars = [
            Car(make: "BMW", model: "330i", customerPrice: 55000, marketPrice: 65000, prosList: ["Good performance", "Stylish design"], consList: ["Expensive maintenance"], rating: 5),
            Car(make: "Audi", model: "A4", customerPrice: 45000, marketPrice: 50000, prosList: ["Great interior", "Smooth ride"], consList: ["High insurance costs"], rating: 4)
        ]
        carViewModel.filteredCars = carViewModel.cars
        carViewModel.makes = ["BMW", "Audi"]
        carViewModel.models = ["330i", "A4"]
        
        return ContentView(viewModel: carViewModel)
    }
}
