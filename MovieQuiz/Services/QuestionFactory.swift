//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Анастасия on 13.03.2026.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    private var movies: [Movie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?){
        self.moviesLoader = moviesLoader
        self.delegate = delegate
        
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case.success(let movies):
                    self.movies = movies
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func setup(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    /* private let questions: [QuizQuestion] = [
     
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
     image: "The Dark Knight" ,
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
     image: "The Green Knight",
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
     */
    
    
    /* func requestNextQuestion() {
     DispatchQueue.global().async { [weak self ] in
     guard let self = self else { return }
     let index = (0..<self.movies.count).randomElement() ?? 0
     
     guard let movie = self.movies[safe: index] else { return }
     
     
     var imageData = Data()
     
     do {
     imageData = try Data(contentsOf: movie.resizedImageURL)
     } catch {
     print("Failed to load image")
     }
     let rating = Float(movie.rating) ?? 0
     
     let text = "Рейтинг этого фильма больше чем 7?"
     let correctAnswer = rating > 7
     
     let question = QuizQuestion (image: imageData,
     text: text,
     correctAnswer: correctAnswer)
     
     DispatchQueue.main.async { [weak self] in
     guard let self = self else { return }
     self.delegate?.didReceiveNextQuestion(question: question)
     }
     }
     }
     }
     */
    
    func requestNextQuestion() {
        let index = (0..<movies.count).randomElement() ?? 0
        guard let movie = movies[safe: index] else { return }
        
        // Картинка из поля poster
        guard let url = URL(string: movie.poster) else {
            // если URL битый, покажем вопрос без картинки
            let question = makeQuestion(from: movie, imageData: Data())
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didReceiveNextQuestion(question: question)
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self = self else { return }
            
            let imageData = data ?? Data()
            if let error = error {
                print("Картинка не загрузилась: \(error.localizedDescription)")
            }
            
            let question = self.makeQuestion(from: movie, imageData: imageData)
            
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didReceiveNextQuestion(question: question)
            }
        }.resume()
    }
    
    private func makeQuestion(from movie: Movie, imageData: Data) -> QuizQuestion {
        let rating = Float(movie.imdbRating) ?? 0
        
        let isGreaterComparison = Bool.random()
        let roundedRating = Int(rating.rounded())
        let offset = Int.random(in: -1...1)
        let threshold = max(1, min(10, roundedRating + offset))
        
        let text: String
        let correctAnswer: Bool
        
        if isGreaterComparison {
            text = "Рейтинг этого фильма больше чем \(threshold)?"
            correctAnswer = rating > Float(threshold)
        } else {
            text = "Рейтинг этого фильма меньше чем \(threshold)?"
            correctAnswer = rating < Float(threshold)
        }
        
        return QuizQuestion(
            image: imageData,
            text: text,
            correctAnswer: correctAnswer
        )
    }
}
