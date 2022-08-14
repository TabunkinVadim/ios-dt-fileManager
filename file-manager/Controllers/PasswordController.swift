//
//  PasswordController.swift
//  file-manager
//
//  Created by Табункин Вадим on 05.08.2022.
//

import UIKit

class PasswordController: UIViewController {

    private let keychainChecker = Checker()
    private var isFirstPassword = true
    private let isChange: Bool
    private let ScrollView: UIScrollView = {
        $0.toAutoLayout()
        return $0
    }(UIScrollView())

    private let contentView: UIView = {
        $0.toAutoLayout()
        return $0
    }(UIView())

    private lazy var setPassword: UITextField = {
        $0.toAutoLayout()
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: $0.frame.height))
        $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: $0.frame.height))
        $0.leftViewMode = .always
        $0.rightViewMode = .always
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 10
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.placeholder = "Введите пароль"
        $0.isSecureTextEntry = true
        $0.delegate = self
        return $0
    }(UITextField())

    private let logInButtom: UIButton = {
        $0.toAutoLayout()
        $0.backgroundColor = UIColor.systemGray5
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 0.5
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(bottomAction), for: .touchUpInside)
        return $0
    }(UIButton())

    private let outButton: UIButton = {
        $0.toAutoLayout()
        $0.backgroundColor = UIColor.systemGray5
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 0.5
        $0.layer.masksToBounds = true
        $0.setTitle("удалить пароль", for: .normal)
        $0.isHidden = true
        $0.addTarget(self, action: #selector(TapDelete), for: .touchUpInside)
        return $0
    }(UIButton())

    init (isChange: Bool) {
        self.isChange = isChange
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLogInButtom() {
        if isChange == false {
            if UserDefaults.standard.bool(forKey: "password") == true {
                logInButtom.setTitle("Введите пароль", for: .normal)
            } else {
                if  isFirstPassword == true {
                    logInButtom.setTitle("Создать пароль", for: .normal)
                }
            }
        } else {
            logInButtom.isHidden = true
            outButton.isHidden = false
        }
    }

    @objc private func bottomAction() {
        if UserDefaults.standard.bool(forKey: "password") == true {
            logInButtom.setTitle("Введите пароль", for: .normal)
            checkPassword ()
        } else {
            if  isFirstPassword == true {
                logInButtom.setTitle("Создать пароль", for: .normal)
                createNewPassword ()
            } else {
                checkNewPassword ()
            }
        }
    }

    private func checkPassword() {
        let password = keychainChecker.keychainGetPassword()
        if setPassword.text! == password{
            dismiss(animated: true)
            navigationController?.pushViewController(MainTabBarController(), animated: true)
        } else {
            let alert: UIAlertController = {
                $0.title = "Ошибка"
                $0.message = "Неверный пароль"
                return $0
            }(UIAlertController())
            alert.addAction(UIAlertAction(title: "Повторить", style: .cancel, handler: { _ in
                self.setPassword.text = ""
            }))
            self.present(alert, animated: true)
        }
    }

    private func createNewPassword() {
        if setPassword.text!.count < 4 {
            let alert: UIAlertController = {
                $0.title = "Ошибка"
                $0.message = "Пароль должен быть 4 и больше знаков"
                return $0
            }(UIAlertController())
            alert.addAction(UIAlertAction(title: "Хорошо", style: .cancel, handler: { _ in
                self.setPassword.text = ""
            }))
            self.present(alert, animated: true)
        } else {
            keychainChecker.pass = self.setPassword.text!
            self.setPassword.text = ""
            self.setPassword.placeholder = "Повторите пероль"
            self.logInButtom.setTitle("Повторите пароль", for: .normal)
            isFirstPassword = false
        }
    }

    private func checkNewPassword() {
        if keychainChecker.pass == setPassword.text! {
            keychainChecker.keychainCreatePassword(password: setPassword.text!)
            checkPassword()
            isFirstPassword = true
        } else {
            let alert: UIAlertController = {
                $0.title = "Ошибка"
                $0.message = "Неверный пароль"
                return $0
            }(UIAlertController())
            alert.addAction(UIAlertAction(title: "Повторить", style: .cancel, handler: { _ in
                self.isFirstPassword = true
                self.logInButtom.setTitle("Создать пароль", for: .normal)
                self.setPassword.placeholder = "Введите пароль"
                self.setPassword.text = ""
                self.keychainChecker.pass = ""
            }))
            self.present(alert, animated: true)
        }
    }

    @objc private func TapDelete() {
        keychainChecker.keychainDeletePassword()
        isFirstPassword = true
        self.logInButtom.setTitle("Создать пароль", for: .normal)
        self.setPassword.text = ""
        keychainChecker.pass = ""
        outButton.isHidden = true
        logInButtom.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(keychainChecker.keychainCheckPasswordSaving(), forKey: "password")
        setLogInButtom()
        layout()
    }

    private func layout() {

        view.backgroundColor = .white
        view.addSubview(ScrollView)

        NSLayoutConstraint.activate([
            ScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            ScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ScrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        ScrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: ScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: ScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: ScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: ScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: ScrollView.widthAnchor)
        ])

        contentView.addSubviews(setPassword, logInButtom, outButton)
        NSLayoutConstraint.activate([
            setPassword.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 200),
            setPassword.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            setPassword.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            setPassword.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            logInButtom.topAnchor.constraint(equalTo: setPassword.bottomAnchor, constant: 60),
            logInButtom.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            logInButtom.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            logInButtom.heightAnchor.constraint(equalToConstant: 70)
        ])

        NSLayoutConstraint.activate([
            outButton.topAnchor.constraint(equalTo: logInButtom.bottomAnchor, constant: 60),
            outButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            outButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            outButton.heightAnchor.constraint(equalToConstant: 70),
            outButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        // подписаться на уведомления
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(kbdShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(kbdHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // отписаться от уведомлений
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // Изменение отступов при появлении клавиатуры
    @objc private func kbdShow(notification: NSNotification) {
        if let kbdSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            ScrollView.contentInset.bottom = kbdSize.height
            ScrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbdSize.height, right: 0) }
    }

    @objc private func kbdHide(notification: NSNotification) {
        ScrollView.contentInset.bottom = .zero
        ScrollView.verticalScrollIndicatorInsets = .zero
    }
}

extension PasswordController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
