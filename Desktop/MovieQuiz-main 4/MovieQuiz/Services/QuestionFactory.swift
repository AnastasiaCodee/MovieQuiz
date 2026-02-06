//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Анастасия on 11.01.2026.
//

import Foundation



class QuestionFactory: QuestionFactoryProtocol  {
    weak var delegate: QuestionFactoryDelegate?

        func setup(delegate: QuestionFactoryDelegate) {
            self.delegate = delegate
        }
    private let questions: [QuizQuestion] = [
        //Mock-данные
        
        QuizQuestion(
            image : "The Godfather",
            //Картинка: The Godfather
            //Настоящий рейтинг: 9,2
            text: "Рейтинг этого фильма больше чем 6?" ,
            //Вопрос: Рейтинг этого фильма больше чем 6?
            correctAnswer: true),
        //Ответ: ДА
        
        QuizQuestion(
            image: "The Dark Knignt" ,
            // Картинка: The Dark Knight
            //Настоящий рейтинг: 9
            text: "Рейтинг этого фильма больше чем 6?",
            //Вопрос: Рейтинг этого фильма больше чем 6?
            correctAnswer: true),
        // Ответ: ДА
        
        QuizQuestion(
            image: "Kill Bill",
            //Картинка: Kill Bill
            //Настоящий рейтинг: 8,1
            text: "Рейтинг этого фильма больше чем 6?",
            // Вопрос: Рейтинг этого фильма больше чем 6?
            correctAnswer: true ),
        //Ответ: ДА
        
        QuizQuestion(
            image: "The Avengers",
            //Картинка: The Avengers
            //Настоящий рейтинг: 8
            text: "Рейтинг этого фильма больше чем 6?",
            //Вопрос: Рейтинг этого фильма больше чем 6?
            correctAnswer: true),
        //Ответ: ДА
        
        QuizQuestion(
            image: "Deadpool",
            //Картинка: Deadpool
            //Настоящий рейтинг: 8
            text: "Рейтинг этого фильма больше чем 6?",
            //Вопрос: Рейтинг этого фильма больше чем 6?
            correctAnswer: true),
        //Ответ: ДА
        
        QuizQuestion(
            image: "The Green Knigt",
            //Картинка: The Green Knight
            //Настоящий рейтинг: 6,6
            text: "Рейтинг этого фильма больше чем 6?",
            //Вопрос: Рейтинг этого фильма больше чем 6?
            correctAnswer: true),
        //Ответ: ДА
        
        
        QuizQuestion(
            image: "Old",
            //Картинка: Old
            //Настоящий рейтинг: 5,8
            text: "Рейтинг этого фильма больше чем 6?",
            //Вопрос: Рейтинг этого фильма больше чем 6?
            correctAnswer: false),
        //Ответ: НЕТ
        
        
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild" ,
            //Картинка: The Ice Age Adventures of Buck Wild
            //Настоящий рейтинг: 4,3
            text: "Рейтинг этого фильма больше чем 6?",
            //Вопрос: Рейтинг этого фильма больше чем 6?
            correctAnswer: false),
        //Ответ: НЕТ
        
        
        QuizQuestion(
            image: "Tesla",
            //Картинка: Tesla
            //Настоящий рейтинг: 5,1
            text: "Рейтинг этого фильма больше чем 6?",
            //Вопрос: Рейтинг этого фильма больше чем 6?
            correctAnswer: false),
        //Ответ: НЕТ
        
        
        QuizQuestion(
            image : "Vivarium",
            //Картинка: Vivarium
            //Настоящий рейтинг: 5,8
            text: "Рейтинг этого фильма больше чем 6?",
            //Вопрос: Рейтинг этого фильма больше чем 6?
            correctAnswer: false)
        //Ответ: НЕТ
    ]
    
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }

        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
}

