//
//  ViewController.swift
//  challenge1.2
//
//  Created by Angela Alves on 22/04/22.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    var allWords = [String]()
    var currentAnswer: String = ""
    var usedLetters = [String]()
    var correctLetters = [String]()
    var wrongLetters = [String]()
    var score = 0 {
        didSet { labelScore.text = "Score: \(score)" }
    }
    var mistakes = 0 {
        didSet { labelError.text = "Mistakes: \(mistakes)" }
    }
    var currentAttempt = "" {
        didSet {
            validateAnswer()
        }
    }

    let labelScore = UILabel()
    var displayedWordLabel = UILabel()
    let labelError = UILabel()
    var labelWrongLetters = UILabel()
    var labelUsedLetters = UILabel()

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        self.view = view
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        builddView()
        getAllWords()
        allWords.shuffle()
        configureLevel()
    }
    
    func getAllWords() {
        if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let content = try? String(contentsOf: wordsURL) {
                allWords = content.components(separatedBy: "\n")
            }
        }
    }
    
    func configureLevel() {
        guard allWords.count > 0 else { return }
        currentAnswer = allWords.removeFirst()

        var maskedWord = ""

        for _ in currentAnswer {
            maskedWord += "*"
        }
        print(currentAnswer)
        displayedWordLabel.text = maskedWord
    }
    
    func restartGame() {
        configureLevel()
        usedLetters.removeAll()
        wrongLetters.removeAll()
        correctLetters.removeAll()
        labelWrongLetters.text = "Wrong letters: \(wrongLetters.joined())"
        labelUsedLetters.text = "Used letters: \(usedLetters.joined())"
    }
    
    @objc func resetGame() {
        restartGame()
        score = 0
        mistakes = 0
    }
    
    func validateAnswer() {
        usedLetters.append(currentAttempt)
        labelUsedLetters.text = "Used letters: \(usedLetters.joined(separator: " - "))"
        if currentAnswer.contains(currentAttempt) {
            correctLetters.append(currentAttempt)
            var displayedWord = ""
            for letter in currentAnswer {
                let strLetter = String(letter)
                if correctLetters.contains(strLetter) {
                    displayedWord += strLetter
                } else {
                    displayedWord += "*"
                }
            }
            displayedWordLabel.text = displayedWord
            if displayedWord == currentAnswer {
                showAlert(title: "Correct", message: "Next word")
                score += 1
            }
        } else {
            wrongLetters.append(currentAttempt)
            labelWrongLetters.text = "Wrong letters: \(wrongLetters.joined(separator: " - "))"
            usedLetters.removeLast()
            mistakes += 1
            if mistakes == 7 {
                youLost()
            } else {
                showAlert(title: "Wrong letter", message: "Try again!")
            }
        }
    }
    
    @objc func promptForAnswer() {
        let alert = UIAlertController(title: "ENTER THE LETTER", message: "Just one", preferredStyle: .alert)
        alert.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak alert] _ in

                guard let answer = alert?.textFields?.first?.text else { return }

                self?.currentAttempt = answer
        }

        alert.addAction(submitAction)
        present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)

        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    func youLost() {
        let ac = UIAlertController(title: "Finished your attempts", message: "You died!", preferredStyle: .alert)

        ac.addAction(UIAlertAction(title: "Start again", style: .default, handler: { _ in
            self.resetGame()
        }))
        present(ac, animated: true)
    }
    
    func builddView() {
        title = "The Hangman"

        labelScore.translatesAutoresizingMaskIntoConstraints = false
        labelScore.text = "SCORE: 0"
        labelScore.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(labelScore)

        labelError.translatesAutoresizingMaskIntoConstraints = false
        labelError.text = "MISTAKES: 0"
        labelError.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(labelError)

        displayedWordLabel.translatesAutoresizingMaskIntoConstraints = false
        displayedWordLabel.text = ""
        displayedWordLabel.font = UIFont.systemFont(ofSize: 55)
        view.addSubview(displayedWordLabel)

        labelWrongLetters.translatesAutoresizingMaskIntoConstraints = false
        labelWrongLetters.text = "Wrong letters:" + ""
        view.addSubview(labelWrongLetters)

        labelUsedLetters.translatesAutoresizingMaskIntoConstraints = false
        labelUsedLetters.text = "Used letters:" + ""
        view.addSubview(labelUsedLetters)

        NSLayoutConstraint.activate([
            labelScore.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            labelScore.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            displayedWordLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            displayedWordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            labelError.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            labelError.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            labelWrongLetters.topAnchor.constraint(equalTo: labelError.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            labelWrongLetters.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            labelWrongLetters.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),

            labelUsedLetters.topAnchor.constraint(equalTo: labelError.safeAreaLayoutGuide.bottomAnchor),
            labelUsedLetters.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            labelUsedLetters.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
        ])

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(resetGame))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
    }
}
