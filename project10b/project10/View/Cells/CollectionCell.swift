//
//  CollectionCell.swift
//  project10
//
//  Created by Angela Alves on 15/07/22.
//

import Foundation
import UIKit

class CollectionCell: UICollectionViewCell {

    static let identifer = "idCell"

    var stackViewCell: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()

    var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .red
        return image
    }()

    var labelName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviewsCell()
        buildCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviewsCell() {
        addSubview(stackViewCell)
        stackViewCell.addArrangedSubview(imageView)
        stackViewCell.addArrangedSubview(labelName)
    }

    func buildCell() {
        NSLayoutConstraint.activate([
            stackViewCell.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackViewCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            stackViewCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            stackViewCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),

            imageView.heightAnchor.constraint(equalTo: stackViewCell.heightAnchor, multiplier: 0.8),
        ])
    }


}
