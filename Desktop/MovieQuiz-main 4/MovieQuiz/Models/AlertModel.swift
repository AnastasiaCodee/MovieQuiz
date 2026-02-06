//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Анастасия on 22.01.2026.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
}
