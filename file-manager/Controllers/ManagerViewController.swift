//
//  ViewController.swift
//  file-manager
//
//  Created by Табункин Вадим on 04.08.2022.
//

import UIKit

class ManagerViewController: UIViewController {

    private var images: [ImageModel] = []
    private let manager = FileManager.default
    private var documentsUrl : URL?
    private var isSort = true

    private lazy var tableView: UITableView = {
        $0.toAutoLayout()
        $0.dataSource = self
        $0.delegate = self
        $0.register(ManagerTableViewCell.self, forCellReuseIdentifier: ManagerTableViewCell.identifier)
        $0.backgroundColor = .white
        return $0
    }(UITableView(frame: .zero, style: .plain))

    init (){
        do {
            self.documentsUrl = try  manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        } catch let error {
            print(error)
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(sortBySize), name: Notification.Name.sortBySize, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sortByName), name: Notification.Name.sortByName, object: nil)
        addExistingImages()
        sortedOnStart()
        layout()
    }

    func sortedOnStart () {
        if UserDefaults.standard.bool(forKey: "sorted") == true {
            sortByName()
        } else {
            sortBySize()
        }
    }

    @objc func sortBySize() {
        self.images = images.sorted(by: {$0.size < $1.size})
        tableView.reloadData()
    }

    @objc func sortByName() {
        self.images = images.sorted(by: {$0.name < $1.name})
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    private func addExistingImages () {
        guard let documentsUrl = self.documentsUrl else {return}
        do {
            let contents = try manager.contentsOfDirectory(atPath: documentsUrl.path)
            for file in contents{
                let name = file

                let url = documentsUrl.appendingPathComponent(file)

                let data = try? Data(contentsOf: url)
                guard let data = data else {continue}

                let image = UIImage(data: data)
                guard let image = image else {continue}

                let attributes = try manager.attributesOfItem(atPath: url.path)
                let size = attributes[.size] as! Int
                images.insert(ImageModel(name: name, url: url, image: image, size: size), at: 0)
            }

        } catch let error {
            print(error)
        }
        tableView.reloadData()
    }

    @objc func addPhoto() {
        let photoPicer: UIImagePickerController = {
            $0.delegate = self
            return $0
        }(UIImagePickerController())
        present(photoPicer, animated: true, completion: nil)
    }

    private func layout () {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addPhoto))
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ManagerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        images.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ManagerTableViewCell
        cell = (tableView.dequeueReusableCell(withIdentifier: ManagerTableViewCell.identifier , for: indexPath) as? ManagerTableViewCell ?? ManagerTableViewCell())
        cell.setupCell(model: images[indexPath.row])
        return cell
    }
}

extension ManagerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") {[weak self] _ , _, _ in
            guard let self = self else {return}
            do {
                try self.manager.removeItem(at: self.images[indexPath.row].url)
            } catch let error {
                print(error)
            }
            self.images.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
        }
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipe
    }
}

extension ManagerViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imageData = image.jpegData(compressionQuality: 1.0)
            guard let documentsUrl = self.documentsUrl else {return}
            var nameNewImage = "image_\(images.count + 1)"
            for image in images {
                if image.name == nameNewImage {
                    nameNewImage = "\(nameNewImage).1"
                }
            }

            let imagePath: URL = documentsUrl.appendingPathComponent(nameNewImage)
            manager.createFile(atPath: imagePath.path, contents: imageData)
            let attributes = try! manager.attributesOfItem(atPath: imagePath.path)
            let size = attributes[.size] as! Int
            images.append(ImageModel(name: nameNewImage, url: imagePath, image: image, size: size))
            sortedOnStart()
            tableView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
}

