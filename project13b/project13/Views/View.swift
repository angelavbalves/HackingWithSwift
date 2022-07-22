//
//  View.swift
//  project13
//
//  Created by Angela Alves on 20/07/22.
//

import Foundation
import UIKit

class View: UIView {

    let delegateController: ViewControllerDelegate?
    let changeFilterAction: () -> Void
    let saveImage: (_ image: UIImage) -> Void

    var viewWithImage: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        view.clipsToBounds = true

        return view
    }()

    var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.clipsToBounds = true

        return image
    }()

    var totalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24

        return stackView
    }()

    var intensityStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        stackView.alignment = .center

        return stackView
    }()

    var radiusStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        stackView.alignment = .center

        return stackView
    }()

    var intensityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Intensity: "
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .gray

        return label
    }()

    var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(ViewController.applyProcessing), for: .allEvents)
        return slider
    }()

    var secondSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(ViewController.blurEffect), for: .allEvents)
        return slider
    }()

    var blurLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Blur: "
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .gray

        return label
    }()

    var buttonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering

        return stackView
    }()

    lazy var changeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change filter", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)

        return button
    }()

    var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        return button
    }()

    init(changeFilterAction: @escaping () -> Void, saveImage: @escaping (_ image: UIImage) -> Void, delegate: ViewControllerDelegate) {
        self.saveImage = saveImage
        self.changeFilterAction = changeFilterAction
        delegateController = delegate
        super.init(frame: .zero)
        backgroundColor = .white
        buildView()
        buildConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func buildView() {
        addSubview(viewWithImage)
        addSubview(totalStack)
        viewWithImage.addSubview(imageView)
        totalStack.addArrangedSubview(intensityStack)
        totalStack.addArrangedSubview(radiusStack)
        totalStack.addArrangedSubview(buttonsStack)
        intensityStack.addArrangedSubview(intensityLabel)
        intensityStack.addArrangedSubview(slider)
        buttonsStack.addArrangedSubview(changeButton)
        buttonsStack.addArrangedSubview(saveButton)
        radiusStack.addArrangedSubview(blurLabel)
        radiusStack.addArrangedSubview(secondSlider)
    }

    func buildConstraints() {
        NSLayoutConstraint.activate([
            viewWithImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 6),
            viewWithImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            viewWithImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            viewWithImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),

            imageView.trailingAnchor.constraint(equalTo: viewWithImage.trailingAnchor, constant: -8),
            imageView.leadingAnchor.constraint(equalTo: viewWithImage.leadingAnchor, constant: 8),
            imageView.topAnchor.constraint(equalTo: viewWithImage.topAnchor, constant: 8),
            imageView.heightAnchor.constraint(equalTo: viewWithImage.heightAnchor, constant: -16),

            totalStack.topAnchor.constraint(equalTo: viewWithImage.bottomAnchor, constant: 22),
            totalStack.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            totalStack.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
        ])
    }

    @objc func filterButtonTapped() {
        guard imageView.image != nil else {
            let ac = UIAlertController(title: "Opss...", message: "You need add a picture in the screen to edit", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            delegateController?.presentAlert(ac)
            return
        }
        changeFilterAction()
    }

    @objc func saveButtonTapped() {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Opss...", message: "You need add a picture in the screen to edit", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            delegateController?.presentAlert(ac)
            return
        }
        saveImage(image)
    }
}
