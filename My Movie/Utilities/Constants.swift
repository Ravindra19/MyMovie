//
//  Constants.swift
//  My Movie
//
//  Created by Ravindra Gaikwad on 01/07/24.
//

import Foundation

class Constants {
    private init() {}
    
    static let shared = Constants()
    
    func getmovieListUrl() -> URL {
        return URL(string: "https://interview-e18de.firebaseio.com/media.json?print=pretty")!
    }
}
