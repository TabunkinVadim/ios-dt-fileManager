//
//  Checker.swift
//  file-manager
//
//  Created by Табункин Вадим on 08.08.2022.
//

import Foundation

final class Checker {
    var pass = ""

    func keychainCheckPasswordSaving () -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "admin",
            kSecAttrService: "fileManager",
            kSecReturnData: true
        ] as CFDictionary
        var extractedData: AnyObject?
        let status = SecItemCopyMatching(query, &extractedData)
        guard status != errSecItemNotFound else {
            return false
        }
        guard status == errSecSuccess else {
            return false
        }
        return true
    }

    func keychainCreatePassword(password: String) {
        guard let passData = password.data(using: .utf8) else {
            print("Невозможно получить данные типа Data из пароля.")
            return
        }
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecValueData: passData,
            kSecAttrAccount: "admin",
            kSecAttrService: "fileManager",
        ] as CFDictionary
        let status = SecItemAdd(attributes, nil)
        guard status == errSecSuccess else {
            print("Невозможно добавить пароль, ошибка номер: \(status).")
            return
        }
        print("Новый пароль добавлен успешно.")
        UserDefaults.standard.set(true, forKey: "password")
    }

    func keychainGetPassword() -> String? {
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "admin",
            kSecAttrService: "fileManager",
            kSecReturnData: true
        ] as CFDictionary
        var extractedData: AnyObject?
        let status = SecItemCopyMatching(attributes, &extractedData)
        guard status != errSecItemNotFound else {
            print("Пароль не найден в Keychain.")
            return nil
        }
        guard status == errSecSuccess else {
            print("Невозможно получить пароль, ошибка номер: \(status).")
            return nil
        }
        guard let passData = extractedData as? Data,
              let password = String(data: passData, encoding: .utf8) else {
            print("Невозможно преобразовать Data в пароль.")
            return nil
        }
        return password
    }

    func keychainDeletePassword() {
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "admin",
            kSecAttrService: "fileManager"
        ] as CFDictionary
        let status = SecItemDelete(attributes)
        guard status == errSecSuccess else {
            print("Невозможно удалить пароль, ошибка номер: \(status).")
            return
        }
        print("Пароль удален успешно.")
        UserDefaults.standard.set(false, forKey: "password")
    }
}
