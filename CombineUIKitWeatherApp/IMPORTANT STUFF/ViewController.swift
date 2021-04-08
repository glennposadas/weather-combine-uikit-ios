//
//  ViewController.swift
//  CombineUIKitWeatherApp
//
//  Created by Glenn Posadas on 4/8/21.
//

import Combine
import UIKit

class ViewController: UIViewController {
  
  // MARK: - Properties
  
  @IBOutlet weak var cityTextField: UITextField!
  @IBOutlet weak var tempLabel: UILabel!
  var viewModel: ViewModel!
  private var cancellables: Set<AnyCancellable> = []
  
  // MARK: - Functions
  // MARK: Overrides
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupBindings()
  }
  
  private func setupBindings() {
    viewModel = ViewModel()
    
    // Bind the city input to the city textField through its reactive/publisher properly (textPublisher).
    cityTextField
        .textPublisher
      .assign(to: \.city, on: viewModel)
      .store(in: &cancellables)
    
    // Observe the value of viewModel's tempPresentable, and bind it to the text of tempLabel.
    viewModel
      .$tempPresentable
      .assign(to: \.text!, on: tempLabel)
      .store(in: &cancellables)
    
  }
}

