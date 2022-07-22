//
//  ViewController.swift
//  project13
//
//  Created by Angela Alves on 19/07/22.
//

import CoreImage
import UIKit

protocol ViewControllerDelegate {
    func presentAlert(_ alertControler: UIAlertController)
}

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter!
    lazy var newView = View(
        changeFilterAction: { [weak self] in self?.changeFilter() },
        saveImage: self.saveImage(_:),
        delegate: self
    )

    override func loadView() {
        view = newView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }

    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }

        dismiss(animated: true)

        currentImage = image

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }

    @objc func applyProcessing() {
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(newView.slider.value, forKey: kCIInputIntensityKey)
            newView.changeButton.setTitle(currentFilter.name, for: .normal)
        } 
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(newView.slider.value * 200, forKey: kCIInputRadiusKey)
            newView.changeButton.setTitle(currentFilter.name, for: .normal)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(newView.slider.value * 10, forKey: kCIInputScaleKey)
            newView.changeButton.setTitle(currentFilter.name, for: .normal)
        }
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
            newView.changeButton.setTitle(currentFilter.name, for: .normal)
        }

        guard let outputImage = currentFilter.outputImage else { return }

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            newView.imageView.image = processedImage
        }
    }

    @objc func blurEffect() {
        guard let currentFilter = CIFilter(name: "CIGaussianBlur") else {
            return
        }
        guard let image = newView.imageView.image else {
            let ac = UIAlertController(title: "Opss...", message: "You need add a picture in the screen to edit", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }

        let beginImage = CIImage(image: image)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter.setValue(10, forKey: kCIInputRadiusKey)

        guard let outputImage = currentFilter.outputImage else {
            return
        }

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            newView.imageView.image = processedImage
        }
    }
    

    func changeFilter() {
        let ac = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(ac, animated: true)
    }

    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }

        guard let actionTitle = action.title else { return }

        currentFilter = CIFilter(name: actionTitle)

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    func saveImage(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(
            image,
            self,
            #selector(image(_:didFinishSavingWithError:contextInfo:)),
            nil
        )
    }
}

extension ViewController: ViewControllerDelegate {
    func presentAlert(_ alertContoller: UIAlertController) {
        present(alertContoller, animated: true)
    }
}
