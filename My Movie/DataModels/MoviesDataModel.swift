//
//  MoviesDataModel.swift
//  My Movie
//
//  Created by Ravindra Gaikwad on 01/07/24.
//

import Foundation

struct MoviesDataModel: Codable {
    let description: String
    let id: String
    let thumb: String
    let title: String
    let url: String
}
