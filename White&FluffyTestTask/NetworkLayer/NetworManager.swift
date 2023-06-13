//
//  NetworkService.swift
//  White&FluffyTestTask
//
//  Created by Влад Енбаев on 13.06.2023.
//

import Foundation

protocol DataManagerProtocol {
    func getImages()
}

class NetworkManager {
    
    private let baseURL = "https/api.unsplash.com/photos/random"
    
    func getImages(searchTerm: String, completion: @escaping (Data?, Error?) -> Void)  {
        
        let parameters = self.prepareParaments(searchTerm: searchTerm)
        let url = self.url(params: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
       
    }
    
    private func prepareHeader() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID BN1-jX1MuvL8gagcdvR7vEaGTbJx9TSRbUsUzV4ltRU"
        return headers
    }
    
    private func prepareParaments(searchTerm: String?) -> [String: String] {
        var parameters = [String: String]()
        parameters["query"] = searchTerm
        parameters["page"] = String(1)
        parameters["per_page"] = String(30)
        return parameters
    }
    
    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data? , Error?) -> Void) -> URLSessionDataTask {
        
    }
}
