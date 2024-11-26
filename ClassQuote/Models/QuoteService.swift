//
//  QuoteService.swift
//  ClassQuote
//
//  Created by Romain Tirbisch on 25/11/2024.
//

import Foundation

class QuoteService {
    
    static var shared = QuoteService()
    
    private static let quoteURL = URL(string: "https://api.forismatic.com/api/1.0/")!
    private static let pictureURL = URL(string: "https://api.unsplash.com/photos/random")!
    
    private var task: URLSessionDataTask?
    
    private init() {}
    
    func getQuote(callback: @escaping (Bool, QuoteModel?) -> Void) {
        var request = URLRequest(url: QuoteService.quoteURL)
        request.httpMethod = "POST"
        
        let body = "method=getQuote&format=json&lang=en"
        request.httpBody = body.data(using: .utf8)
        
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: request) {
            data,
            response,
            error in
            DispatchQueue.main.async {
                guard let data,
                      error == nil else {
                    callback(false, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                
                guard let responseJson = try? JSONDecoder().decode([String:String].self, from: data),
                      let quote = responseJson["quoteText"],
                      let author = responseJson["quoteAuthor"] else {
                    callback(false, nil)
                    return
                }
                
                self.getImage { imageData in
                    guard let imageData else {
                        callback(false, nil)
                        return
                    }
                    
                    let quote = QuoteModel(
                        quote: quote,
                        author: author,
                        imageData: imageData
                    )
                    callback(true, quote)
                }
            }
        }
        task?.resume()
    }
    
    func getImage(completionHandler: @escaping (Data?) -> Void) {
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: QuoteService.pictureURL) { data, response, error in
            DispatchQueue.main.async {
                guard let data, error == nil else {
                    completionHandler(nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil)
                    return
                }
                
                completionHandler(data)
            }
        }
        task?.resume()
    }
}
