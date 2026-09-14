import UIKit

//MARK: - Main View Controller

final class MovieQuizViewController: UIViewController {
    
    //MARK: - IB Outlets
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Private Properties
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter = AlertPresenter()
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI ()
        
        let factory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        questionFactory = factory
        
        showLoadingIndicator()
        questionFactory?.loadData()
        
    }
    
    private func setupUI () {
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        
        yesButton.layer.cornerRadius = 15
        yesButton.layer.masksToBounds = true
        
        noButton.layer.cornerRadius = 15
        noButton.layer.masksToBounds = true
        
        resetImageViewBorder()
        
    }
    
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    //MARK: - IB Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        handleAnswer(false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        handleAnswer(true)
        
    }
    
    private func handleAnswer(_ givenAnswer: Bool) {
        disableButtons()
        
        guard let currentQuestion = currentQuestion else { return }
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonTitle: "Попробовать ещё раз") { [weak self] in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.showLoadingIndicator()
            
            self.questionFactory?.loadData()
        }
        alertPresenter.show(in: self, model: model)
    }
    
    //MARK: - Public Methods
    
    //
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    //MARK: - Private Methods
    
    private func disableButtons() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    private func enableButtons () {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    private func resetImageViewBorder() {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        resetImageViewBorder()
        enableButtons()
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        disableButtons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [ weak self ] in
            guard let self = self else { return }
            self.resetImageViewBorder()
            self.showNextQuestionOrResults()
            
        }
    }
    
    private func showNextQuestionOrResults() {
        guard currentQuestionIndex == questionsAmount - 1 else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
            enableButtons()
            return
        }
        let text = correctAnswers == questionsAmount ?
        "Поздравляем, вы ответили на 10 из 10!" :
        "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
        
        let viewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: text,
            buttonText: "Сыграть ещё раз")
        
        show(quiz: viewModel)
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let bestGame = statisticService.bestGame
        let dateString = bestGame.date.dateTimeString
        let currentRecultText = "Ваш результат \(correctAnswers) /\(questionsAmount)"
        
        let message = """
            \(currentRecultText)
            Вы сыграли \(statisticService.gamesCount) игр
            Рекорд: \(bestGame.correct) /\(bestGame.total) (\(dateString))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
        
        let model = AlertModel(
            
            title: result.title,
            message: message,
            buttonTitle: result.buttonText,
            completion: { [weak self] in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.enableButtons()
                self.questionFactory?.requestNextQuestion()
            }
        )
        alertPresenter.show(in: self, model: model)
    }
}

// MARK: - QuestionFactoryDelegate

extension MovieQuizViewController: QuestionFactoryDelegate {
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self]  in
            self?.show(quiz: viewModel)
            
        }
    }
}


