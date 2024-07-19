//
//  APIService.swift
//  My Movie
//
//  Created by Ravindra Gaikwad on 01/07/24.
//

import Foundation

//MARK: Generic class to fetch API Data
class APIService {
    func getApiData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler: @escaping (_ result: T)-> Void, failureHandler: @escaping (String)-> Void)
    {
        URLSession.shared.dataTask(with: requestUrl) { (responseData, httpUrlResponse, error) in

            if(error == nil && responseData != nil && responseData?.count != 0)
            {
                //parse the responseData here
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(T.self, from: responseData!)
                    _=completionHandler(result)
                }
                catch let error{
                    failureHandler(error.localizedDescription)
                }
            }

        }.resume()
    }
}
