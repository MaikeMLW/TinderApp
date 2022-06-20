//
//  PeopleViewController.swift
//  TinderApp
//
//  Created by Timofey on 27/5/22.
//

import UIKit

class PeopleViewController: UIViewController {

  var cardContainer: CardContainerView!
  var reactionsView: ReactionButtonsView!
  var titleLabel: UILabel!
  let headerOvalLayerMask = CAShapeLayer()
  var gradientLayer: CAGradientLayer!
  
  override func viewDidLoad() {
      super.viewDidLoad()
      self.view.backgroundColor = UIColor(named: "peopleBG")!
      setupElements()
    }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    actualizePath()
  }
  
  func actualizePath() {
    let width = Int(view.bounds.width * 1.289)
    let height = Int(view.bounds.height * 0.385)
    let x = Int(self.view.center.x) - width / 2
    let y = -Int(self.view.bounds.maxY * 0.1)
    print("x \(x) y \(y)")
    let path = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: Int(width), height: height)).cgPath
    headerOvalLayerMask.path = path
    gradientLayer.frame = CGRect(x: 0, y: 0, width: Int(width), height: height)
  }
  
  private func setupElements() {
    setupHeaderOvalLayer()
    setupReactionsView()
    setupCardContainer()
    setupTitleLabel()
  }
  
  private func setupTitleLabel() {
    titleLabel = UILabel()
    titleLabel.text = "People Nearby"
    titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
    titleLabel.textColor = UIColor(named: "peopleBG") ?? .black
    
    view.addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(70)
      make.leading.equalToSuperview().offset(Constants.cardContainerHorizontalOffsetMultiplier * self.view.bounds.width)
    }
  }
  
  private func setupReactionsView(){
    reactionsView = ReactionButtonsView()
    reactionsView.delegate = self
    
    view.addSubview(reactionsView)
    
    let tabBarFrame = self.tabBarController!.tabBar.frame
    print(tabBarFrame)
    reactionsView.snp.makeConstraints { make in
      make.bottom.equalTo(tabBarFrame.origin.y).offset(-self.view.bounds.height * Constants.buttonsBottomOffsetMultiplier)
      make.leading.equalToSuperview().offset(self.view.bounds.width * Constants.buttonsHorizontalOffsetMultiplier)
      make.trailing.equalToSuperview().offset(-self.view.bounds.width * Constants.buttonsHorizontalOffsetMultiplier)
      make.height.equalTo(75)
    }
  }

  private func setupCardContainer() {
    let viewModel = CardContainerViewViewModel(users: [
      .init(),
      .init()])
    cardContainer = CardContainerView(viewModel: viewModel)
    
    view.addSubview(cardContainer)
    
    cardContainer.snp.makeConstraints { make in
      make.leading.equalTo(self.view.snp.leading).offset(Constants.cardContainerHorizontalOffsetMultiplier * self.view.bounds.width)
      make.trailing.equalTo(self.view.snp.trailing).offset(-Constants.cardContainerHorizontalOffsetMultiplier * self.view.bounds.width)
      make.height.equalTo(Constants.cardContainerHeightMultiplier * self.view.bounds.height)
      make.bottom.equalTo(reactionsView.snp.top).offset(-30)
    }
    cardContainer.delegate = self
    cardContainer.layer.zPosition = 1
  }

}

extension PeopleViewController: CardContainerDelagate {
  func usersLoaded() {
    print("loaded")
  }
}


extension PeopleViewController: ReactionViewDelegate {
  func reacted(liked: Bool) {
    cardContainer.reacted(liked: liked)
  }
}
