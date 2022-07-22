//
//  ViewController.swift
//  project10
//
//  Created by Angela Alves on 15/07/22.
//

import UIKit

protocol CollectionDelegate {
    func getDocumentsDirectory() -> URL
    func presentAlert(sender: UIAlertController)
}

class CollectionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    lazy var collectionView = CollectionView(delegateController: self)

    override func loadView() {
        view = collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }

    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary

        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }

        let person = Person(name: "Unknown", image: imageName)
        collectionView.updateCollectionView(person: person)

        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}

extension CollectionViewController: CollectionDelegate {

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func presentAlert(sender: UIAlertController) {
        present(sender, animated: true)
    }
}
