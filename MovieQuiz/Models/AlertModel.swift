//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Анастасия on 18.03.2026.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonTitle: String
    var completion: () -> Void
    
}
