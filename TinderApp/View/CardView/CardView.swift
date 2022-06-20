//
//  CardView.swift
//  TinderApp
//
//  Created by Timofey on 30/5/22.
//

import UIKit
import SnapKit
import Kingfisher

enum CardViewConstants {
  static let xShift: CGFloat = 300
  static let swipedAngle: CGFloat = 30 * .pi / 180
  static let maxDeltaForHiddenViewMultiplier: CGFloat = 0.16
  static let maxDelta: CGFloat = 130
  static let maxVelocity: CGFloat = 1000
  static let maxAngle: CGFloat = .pi / 8
  static let topCardHorizontalOffset: CGFloat = 12
  static let topCardTopOffset: CGFloat = 5
  static let topCardBottomOffset: CGFloat = 11
  static let xTranslateMultiplier: CGFloat = 0.8
  static let yTranslateMultiplier: CGFloat = 0.3
}

class CardView: UIView {
  
  var viewModel: UserCardViewViewModelProtocol
  var delegate: CardViewDeleagate?
  
  var anchorPoint: CGPoint = .zero
  var startPoint: CGPoint = .zero
  
  var profileImage = UIImageView()
  var nameAgeLabel = UILabel()
  var cityDistanceLabel = UILabel()
  var userInfoblurView: UIVisualEffectView!
  var compatabilityView: CompatabilityView!
  var hiddenTopReactionView: HiddenReactionViewProtocol!
  
  init(with viewModel: UserCardViewViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    setupElements()
    setupGestures()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.startPoint = center
  }
  
  init() {
    let viewModel = UserCardViewViewModel()
    self.viewModel = viewModel
    super.init(frame: .zero)
    setupElements()
    setupGestures()
  }
  
  func updateCard(with viewModel: UserCardViewViewModelProtocol) {
    self.viewModel = viewModel
    fillUI()
  }
  
  func swipe(liked: Bool, fromButton: Bool = false) {
    let xShift: CGFloat = liked ? CardViewConstants.xShift : -CardViewConstants.xShift
    let angle: CGFloat = liked ? CardViewConstants.swipedAngle : -CardViewConstants.swipedAngle
    let duration = fromButton ? Constants.cardDisappearTime * 3 : Constants.cardDisappearTime
    UIView.animate(withDuration: duration) { [unowned self] in
      self.transform = CGAffineTransform(rotationAngle: angle)
      self.center.x += xShift
      self.hiddenTopReactionView.toggleReaction(like: liked)
      self.hiddenTopReactionView.alpha = 1
      self.alpha = 0
    } completion: { _ in
      self.transform = .identity
      self.hiddenTopReactionView.alpha = 0
      self.center = self.startPoint
      self.delegate?.swiped(liked: liked)
    }
  }

  private func fillUI() {
    cityDistanceLabel.text = viewModel.cityDistanceLabelText()
    nameAgeLabel.text = viewModel.nameAgeLabelText()
    guard let url = URL(string: viewModel.imageUrlString) else { return }
    compatabilityView.updateScore(with: viewModel.compatabilityScore)
    profileImage.kf.setImage(with: url)
  }
  
  private func setupElements() {
    self.backgroundColor = .randomColor()
    clipsToBounds = true
    layer.cornerRadius = 20
    layer.borderWidth = 0.2
    layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
    setupImageView()
    setupUserInfoView()
    setupCompatabilityView()
    setupHiddenTopReactionView()
    fillUI()
  }
  
  func setupHiddenTopReactionView() {
    hiddenTopReactionView = HiddenReactionView()
    hiddenTopReactionView.alpha = 0
    
    addSubview(hiddenTopReactionView)
    
    hiddenTopReactionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupCompatabilityView() {
    compatabilityView = CompatabilityView(with: viewModel.compatabilityScore)
    
    userInfoblurView.contentView.addSubview(compatabilityView)
    
    compatabilityView.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-24)
      make.height.width.equalTo(60)
      make.centerY.equalToSuperview()
    }
  }
  
  private func setupUserInfoView() {
    let blur = UIBlurEffect(style: .dark)
    userInfoblurView = UIVisualEffectView(effect: blur)
    
    let nameLabelFont = UIFont.systemFont(ofSize: 24, weight: .bold)
    let cityFont = UIFont.systemFont(ofSize: 12, weight: .bold)
    nameAgeLabel.font = nameLabelFont
    cityDistanceLabel.font = cityFont
    nameAgeLabel.textColor = UIColor(named: "cardLabelTextColor") ?? .white
    cityDistanceLabel.textColor = UIColor(named: "cardLabelTextColor") ?? .black
    
    let labelsStackView = UIStackView(arrangedSubviews: [nameAgeLabel, cityDistanceLabel])
    labelsStackView.distribution = .equalSpacing
    labelsStackView.alignment = .leading
    labelsStackView.axis = .vertical
    labelsStackView.spacing = 2
    
    addSubview(userInfoblurView)
    userInfoblurView.contentView.addSubview(labelsStackView)
    
    userInfoblurView.snp.makeConstraints { make in
      make.leading.bottom.trailing.equalToSuperview()
      make.height.equalToSuperview().multipliedBy(0.185)
    }
    
    labelsStackView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(24)
      make.centerY.equalToSuperview()
    }
    
  }
  
  private func setupImageView() {
    addSubview(profileImage)
    profileImage.contentMode = .scaleAspectFill
    profileImage.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
