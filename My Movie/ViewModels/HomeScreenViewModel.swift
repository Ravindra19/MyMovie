//
//  HomeScreenViewModel.swift
//  My Movie
//
//  Created by Ravindra Gaikwad on 01/07/24.
//

import Foundation

//MARK: HomeScreenViewModel to manage the API and CoreData calls for home screen

protocol HomeScreenViewModelProtocal {
    func getMovieList(success successCallback: @escaping (_ data: [Movies]) -> Void, error errorCallback: @escaping (String) -> Void)
}


class HomeScreenViewModel: HomeScreenViewModelProtocal {
    
    //MARK: Function to get list of movies from server if its not present in database
    
    func getMovieList(success successCallback: @escaping ([Movies]) -> Void, error errorCallback: @escaping (String) -> Void) {
        
        self.fetchMoviesFromDatabase(successCallback: { movieList in
            if movieList.count > 0 {
                successCallback(movieList)
            } else {
                APIService().getApiData(requestUrl: Constants.shared.getmovieListUrl(), resultType: [MoviesDataModel].self) { movieResult in
                    
                    for i in movieResult {
                        let moviesData = Movies(context: PersistantStorage.shared.context)
                        moviesData.id = i.id
                        moviesData.descriptions = i.description
                        moviesData.thumb = i.thumb
                        moviesData.title = i.title
                        moviesData.url = i.url
                        moviesData.lastPlayed = 0
                        PersistantStorage.shared.saveContext()
                    }
                    
                    self.fetchMoviesFromDatabase(successCallback: { movieList in
                        successCallback(movieList)
                    }, error: { errorStr in
                        errorCallback(errorStr)
                    })
                } failureHandler: { error in
                    errorCallback(error)
                }
            }
        }, error: { errorStr in
            errorCallback(errorStr)
        })
    }
    
    //MARK: Function to get all movies from database
    func fetchMoviesFromDatabase(successCallback: @escaping ([Movies]) -> Void, error errorCallback: @escaping (String) -> Void) {
        do {
            guard let result = try PersistantStorage.shared.context.fetch(Movies.fetchRequest()) as? [Movies] else { return }
            successCallback(result)
        } catch let error {
            errorCallback(error.localizedDescription)
        }
    }
    
    //MARK: Function to get selected movie from database
    func fetchSelectedMovieFromDatabase(movieID: String) -> Movies? {
        do {
            let fetchRequest = Movies.fetchRequest()
            let predicate = NSPredicate(format: "id==%@", movieID)
            fetchRequest.predicate = predicate
            guard let result = try PersistantStorage.shared.context.fetch(fetchRequest).first as? Movies else { return nil }
            return result
        } catch let error {
            return nil
        }
    }
    
    //MARK: Function to update playing movie time into the database
    func updateSelectedMovie(movie: Movies, lastPlayed: Int64) -> Bool {
        let selectedMovie = self.fetchSelectedMovieFromDatabase(movieID: movie.id ?? "")
        guard selectedMovie != nil else { return false }
        selectedMovie?.lastPlayed = lastPlayed
        PersistantStorage.shared.saveContext()
        return true
    }
}
