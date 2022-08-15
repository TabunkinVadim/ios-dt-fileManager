//
//  SettingsCell.swift
//  file-manager
//
//  Created by Табункин Вадим on 10.08.2022.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    private let parametr :UILabel = {
        $0.toAutoLayout()
        $0.font = UIFont(name: "SFProText-Regular", size: 17)
        $0.textColor = .black
        return $0
    } (UILabel())

    private let sortingSwitch: UISwitch = {
        $0.toAutoLayout()
        $0.isOn = true
        $0.addTarget(self, action: #selector(switching(sw:)), for: .valueChanged)
        return $0
    }(UISwitch())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        switching(sw: sortingSwitch)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func switching(sw: UISwitch) {
        if sw.isOn {
            UserDefaults.standard.set(true, forKey: "sorted")
            parametr.text = "Сортировка по имени"
            reloadInputViews()
            NotificationCenter.default.post(name: NSNotification.Name.sortByName, object: nil)
        } else {

            UserDefaults.standard.set(false, forKey: "sorted")
            parametr.text = "Сортировка по размеру"
            reloadInputViews()
            NotificationCenter.default.post(name: NSNotification.Name.sortBySize, object: nil)
        }
    }

    func setupCell(text: String) {
        parametr.text = text
    }
    
    private func layout () {
        contentView.addSubviews(parametr, sortingSwitch)
        NSLayoutConstraint.activate([
            parametr.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            parametr.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            sortingSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sortingSwitch.widthAnchor.constraint(equalToConstant: 30),
            sortingSwitch.heightAnchor.constraint(equalToConstant: 30),
            sortingSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -36)
        ])
    }
    

}
