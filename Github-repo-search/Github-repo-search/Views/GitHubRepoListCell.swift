//
//  GitHubRepoListCell.swift
//  Github-repo-search
//
//  Created by Suman Chatterjee on 12/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import UIKit


class GitHubRepoListCell: UITableViewCell {

  enum CellConstant {
    static let tralingContentPadding: CGFloat = 10
    static let leadingContentPadding: CGFloat = 8
    static let topAndBottomPadding: CGFloat = 5
  }


  let repoLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    label.text = ""
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .darkGray
    return label
  }()

  let creationDateLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    label.text = ""
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .lightGray
    return label
  }()

  let repoDescriptionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    label.text = ""
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .lightGray
    return label
  }()

  let userName: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .darkGray
    return label
  }()

  let avaterImageView: UIImageView = {
    let imgView = UIImageView()
    imgView.clipsToBounds = true
    imgView.contentMode = .scaleAspectFill
    imgView.layer.masksToBounds = true
    imgView.layer.cornerRadius = imgView.bounds.width / 2
    imgView.translatesAutoresizingMaskIntoConstraints = false
    return imgView
  }()

  lazy var toplavelStackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews: [self.repoLabel, self.creationDateLabel])
    sv.axis = .horizontal
    sv.alignment = .fill
    sv.spacing = 3
    sv.translatesAutoresizingMaskIntoConstraints = false
    return sv
  }()

  lazy var bottomlavelStackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews: [self.avaterImageView, self.userName])
    sv.axis = .horizontal
    sv.alignment = .fill
    sv.spacing = 8
    sv.translatesAutoresizingMaskIntoConstraints = false
    return sv
  }()

  lazy var contaterStackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews: [self.toplavelStackView, self.repoDescriptionLabel, self.bottomlavelStackView])
    sv.axis = .vertical
    sv.alignment = .fill
    sv.spacing = 3
    sv.translatesAutoresizingMaskIntoConstraints = false
    return sv
  }()


  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }


  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  func configureCell(_ cellViewModel: GitHubCellViewModel) {
    repoLabel.text = cellViewModel.name
    creationDateLabel.text = cellViewModel.createdAt
    repoDescriptionLabel.text = cellViewModel.description
    userName.text = cellViewModel.userName
    cellViewModel.getAvaterImage { [weak self] result in
      switch result {
      case .success(let image):
        self?.avaterImageView.image = image
        self?.setNeedsDisplay()
      case .failure(let appError):
        print(appError.localizedDescription)
      }
    }
  }
}

extension GitHubRepoListCell {

  private func setupCell() {
    addSubview(contaterStackView)
    NSLayoutConstraint.activate([
      avaterImageView.heightAnchor.constraint(equalToConstant: 40),
      avaterImageView.widthAnchor.constraint(equalToConstant: 40),
      contaterStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
      contaterStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
      contaterStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CellConstant.tralingContentPadding),
      contaterStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CellConstant.leadingContentPadding)
      ,
      contaterStackView.topAnchor.constraint(equalTo: topAnchor),
      contaterStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
      ])
  }
}
