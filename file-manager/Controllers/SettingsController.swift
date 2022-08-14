//
//  SettingsController.swift
//  file-manager
//
//  Created by Табункин Вадим on 09.08.2022.
//

import UIKit

class SettingsController: UIViewController {

    private lazy var tableView: UITableView = {
        $0.toAutoLayout()
        $0.dataSource = self
        $0.delegate = self
        $0.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        $0.backgroundColor = .white
        return $0
    }(UITableView(frame: .zero, style: .plain))

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }

    private func layout () {

        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SettingsController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = SettingsCell()
            cell.parametr.text = "Сортировать по имени"
            return cell
        } else {
            let cell = UITableViewCell()
            var content: UIListContentConfiguration = cell.defaultContentConfiguration()
            content.text = "Изменить пароль"
            cell.contentConfiguration = content
            return cell
        }
    }
}

extension SettingsController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let vc = PasswordController(isChange: true)
            navigationController?.present (vc, animated: true )
        }
    }
}


