//
//  CardContainerDelegate.swift
//  TinderApp
//
//  Created by Timofey on 3/6/22.
//

import Foundation


protocol CardContainerDelagate: AnyObject {
  func usersLoaded()
  func cardTouched(with viewModel: UserCardViewViewModelProtocol)
}

