//
//  CollectionView.swift
//  project10
//
//  Created by Angela Alves on 15/07/22.
//

import Foundation
import UIKit

class CollectionView: UIView {
    
    var delegateController: CollectionDelegate?
    var people = [Person]()
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self

        return cv
    }()

    init(delegateController: CollectionDelegate) {
        self.delegateController = delegateController
        super.init(frame: .zero)
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.identifer)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        addSubview(collectionView)
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }

    func updateCollectionView(person: Person) {
        people.append(person)
        collectionView.reloadData()
    }
}

extension CollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        let alertController = UIAlertController(title: "Delete or Edit?", message: "Do you wish delete or rename this person?", preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] _ in
            let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            ac.addTextField()

            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak ac] _ in
                guard let newName = ac?.textFields?[0].text else { return }
                person.name = newName

                self?.collectionView.reloadData()
            })
            self?.delegateController?.presentAlert(sender: ac)

        }))
        alertController.addAction(UIAlertAction(title: "Delete", style: .default, handler: { [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.reloadData()
        }))

        delegateController?.presentAlert(sender: alertController)
    }
}

extension CollectionView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        people.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifer, for: indexPath) as? CollectionCell else {
            fatalError("Unable to dequeue PersonCell")
        }

        let person = people[indexPath.item]
        cell.labelName.text = person.name

        let path = delegateController?.getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path?.path ?? "Problem in converter String to URL")

        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        cell.layer.backgroundColor = UIColor.lightGray.cgColor

        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
}

extension CollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width * 0.45
        return CGSize(width: width, height: width * 1.5)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 25, left: 15, bottom: 15, right: 15)
    }
}
