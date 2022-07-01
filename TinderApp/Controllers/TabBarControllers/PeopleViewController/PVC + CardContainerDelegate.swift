//
//  PVC + CardContainerDelegate.swift
//  TinderApp
//
//  Created by Timofey on 1/7/22.
//

import UIKit

extension PeopleViewController: CardContainerDelagate {
  
  func cardTouched(with viewModel: UserCardViewViewModelProtocol) {
    userView.viewModel = viewModel
    userView.show()
  }
  
  func usersLoaded() {
    print("loaded")
  }
}
