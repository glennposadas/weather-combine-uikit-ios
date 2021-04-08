//
//  ViewModel.swift
//  CombineUIKitWeatherApp
//
//  Created by Glenn Posadas on 4/8/21.
//

import Combine
import Foundation

final class ViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private var cancellables: Set<AnyCancellable> = []
  
  // MARK: - Inputs
  
  // Needs initial value.
  @Published var city: String = "Manila"
  
  // MARK: - Outputs
  
  // Needs initial value.
  @Published var weather: WeatherDetail = WeatherDetail.placeholder
  
  // The presentable temperature.
  @Published var tempPresentable: String = "0 ºC"
  
  // MARK: - Functions
  // MARK: Overrides
  
  init() {
    // Listen, observe the data streams to city, wrapped as a published.
    // Listen to city changes.
    // And then call the API's `fetchWeather`.
    // Then the result will be sent to the keyPath (see the "\." part),
    // key path of the `weather` varaiable in thsi viewModel.
    //
    // Note that the city is an input
    // and the weather is an output.
    // We listen to the city, and the view listens for the weather changes.
    //
    // If you can see, the `$city` is typed as Publisher, specifically
    // Published<City-Original-Type>.Publisher
    $city
        .debounce(for: 0.3, scheduler: RunLoop.main)
        .removeDuplicates()
        .flatMap { (city:String) -> AnyPublisher <WeatherDetail, Never> in
            API.shared.getWeather(for: city)
          }
         .assign(to: \.weather , on: self)
        .store(in: &cancellables)
    
    // Another version:
    // Try to listen to weather changes and then send value to `tempPresentable`.
    // The view/controller can listen to any of the two outputs in this viewModel.
    $weather
      .flatMap { (weather) -> AnyPublisher<String, Never> in
        Just("\(weather.main?.temp ?? 0) ºC")
          .eraseToAnyPublisher()
      }
      .assign(to: \.tempPresentable, on: self)
      .store(in: &cancellables)
  }
}
