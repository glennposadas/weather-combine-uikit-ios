//
//  UITextField+Publisher.swift
//  CombineUIKitWeatherApp
//
//  Created by Glenn Posadas on 4/8/21.
//

import Combine
import UIKit

extension UITextField {
  /// `AnyPublisher` seems like a generic version of `Publisher`.
  /// If you change this type to publisher, compiler would complain about this being non-generic.
  /// You will bind this property or assign to a `vieWModel`.
  /// Think of this object as a value emitter. Every changes or signals coming in this property (that is from `textDidChangeNotification`),
  /// will be sent to the `viewModel`,
  var textPublisher: AnyPublisher<String, Never> {
    NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification)
      .compactMap { $0.object as? UITextField }
      .map { $0.text ?? ""}
      .eraseToAnyPublisher()
  }
}
