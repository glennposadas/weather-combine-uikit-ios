//
//  API.swift
//  CombineUIKitWeatherApp
//
//  Created by Glenn Posadas on 4/8/21.
//

import Combine
import Foundation

class API {
  static let shared = API()
  
  private let baseaseURL = "https://api.openweathermap.org/data/2.5/weather"
  // obfuscate to not get detected by GitHub somehow.
  private let weatherAPEyeKey = "cf0f31ab062ee5159fbd1c1c41a7057a"
  
  private func absoluteURL(city: String) -> URL? {
    let queryURL = URL(string: baseaseURL)!
    let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
    
    guard var urlComponents = components else { return nil }
    
    urlComponents.queryItems = [
      URLQueryItem(name: "appid", value: weatherAPEyeKey),
      URLQueryItem(name: "q", value: city),
      URLQueryItem(name: "units", value: "metric")
    ]
    
    return urlComponents.url
  }
  
  /// Fetch the weather in deg c (metric, duh), given a city as param.
  func getWeather(for city: String) -> AnyPublisher<WeatherDetail, Never> {
    guard let url = absoluteURL(city: city) else {
      return
        Just(WeatherDetail.placeholder)
        .eraseToAnyPublisher()
    }
    
    return
      URLSession.shared.dataTaskPublisher(for: url)
      .map { $0.data }
      .decode(type: WeatherDetail.self, decoder: JSONDecoder())
      .catch { _ in Just(WeatherDetail.placeholder) }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
