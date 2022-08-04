//
//  managerCell.swift
//  file-manager
//
//  Created by Табункин Вадим on 04.08.2022.
//

import UIKit

class ManagerCell: UITableViewCell {

    let image: UIImageView = {
        $0.toAutoLayout()
        return $0
    }(UIImageView())

    let nameImage :UILabel = {
        $0.toAutoLayout()
        $0.font = UIFont(name: "SFProText-Regular", size: 17)
        $0.textColor = .black
        return $0
    } (UILabel())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupCell(model: ImageModel) {
        self.nameImage.text = model.name
        self.image.image = model.image
    }

    private func layout () {
        contentView.addSubviews(image, nameImage)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            image.widthAnchor.constraint(equalToConstant: 50),
            image.heightAnchor.constraint(equalToConstant: 50),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        ])

        NSLayoutConstraint.activate([
            nameImage.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 12),
            nameImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 12)
        ])
    }
}
