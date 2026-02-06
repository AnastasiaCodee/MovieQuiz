//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Анастасия on 22.01.2026.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)    
}


