import UIKit

final class MovieQuizViewController: UIViewController  {
    
    //MARK: - IB Outlets
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noButtonClicked: UIButton!
    
    @IBOutlet private weak var yesButtonClicked: UIButton!
    
    //MARK: - Properties
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private let alertPresenter = AlertPresenter()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        print(Bundle.main.bundlePath)
        let questionFactory = QuestionFactory()
        //questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        
        questionFactory.requestNextQuestion()
        
    }
    
    //для состояния вопрос показан
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    // для состояния "Результат квиза"
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    //структура вопроса
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
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
    
    
    //    func requestNextQuestion() {
    //        guard let index = (0..<questions.count).randomElement() else {
    //            delegate?.didReceiveNextQuestion(question: nil)
    //            return
    //        }
    //
    //        let question = questions[safe: index]
    //        delegate?.didReceiveNextQuestion(question: question)
    //    }
    //}
    //    // MARK: - QuestionFactoryDelegate
    //
    //    func didReceiveNextQuestion(question: QuizQuestion?) {
    //        guard let question = question else {
    //            return
    //        }
    //
    //        currentQuestion = question
    //        let viewModel = convert(model: question)
    //
    //        DispatchQueue.main.async
    //        { [weak self] in
    //            self?.show(quiz: viewModel)
    //        }
    //    }
    //
    // MARK: - Private functions
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        let questionStep = QuizStepViewModel (
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { 
            self.showNextQuestionOrResults()
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)  
    
    let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
        self.currentQuestionIndex = 0
        self.correctAnswers = 0
        
        let firstQuestion = self.questions[self.currentQuestionIndex]
        let viewModel = self.convert(model: firstQuestion)
        self.show(quiz: viewModel)
    }
    
    alert.addAction(action)
    
    self.present(alert, animated: true, completion: nil)
}
        
    func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}

