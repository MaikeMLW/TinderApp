//
//  ReactionViewDelegate.swift
//  TinderApp
//
//  Created by Timofey on 8/6/22.
//

import Foundation

protocol ReactionViewDelegate: AnyObject {
  func reacted(liked: Bool)
}
