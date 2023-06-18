//
//  NetworkService.swift
//  White&FluffyTestTask
//
//  Created by Влад Енбаев on 13.06.2023.
//

import Foundation

fileprivate enum HTTPMethod {
    static let post = "POST"
    static let put = "PUT"
    static let get = "GET"
    static let delete = "DELETE"
}

    
fileprivate enum UnsplashResources {
    
    enum URLSettings {
        static let scheme = "https"
        static let host = "api.unsplash.com"
        static let randomPhotosPath = "/photos/random"
        static let searchPhotosPath = "/search/photos"
    }
    
    enum Parameters {
        static let count = "count"
        static let query = "query"
        static let page = "page"
        static let perPage = "per_page"
    }
    
    static let authID = "BN1-jX1MuvL8gagcdvR7vEaGTbJx9TSRbUsUzV4ltRU"
}

protocol NetworkServiceProtocol {
    func getRandomImages(count: Int, completion: @escaping (Result<[UnsplashPhoto], Error>) -> Void)
    func getImages(query: String, completion: @escaping (Result<UnsplashSearchResults, Error>) -> Void)
}

class NetworkService {
    
    private func getURLSession<T: Decodable>(with urlRequest: URLRequest, completionHandler: @escaping (Result<T, Error>) -> Void){
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            guard let data = data else {
                let response = response as? HTTPURLResponse
                let error = NSError(domain: "", code: response?.statusCode ?? 0)
                completionHandler(.failure(error))
                return
            }
            
            if let error = error{
                completionHandler(.failure(error))
            } else {
                do{
                    let recievedData = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(recievedData))
                } catch {
                    completionHandler(.failure(error))
                }
            }
        }
        task.resume()
    }
}

extension NetworkService: NetworkServiceProtocol {
    
    func getRandomImages(count: Int, completion: @escaping (Result<[UnsplashPhoto], Error>) -> Void)  {
        let parameters = [
            UnsplashResources.Parameters.count : "\(count)"
        ]
        
        let url = createQueryURL(path: UnsplashResources.URLSettings.randomPhotosPath, params: parameters)
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = createHeader()
        request.httpMethod = HTTPMethod.get
        
        getURLSession(with: request, completionHandler: completion)
       
    }
    
    func getImages(query: String, completion: @escaping (Result<UnsplashSearchResults, Error>) -> Void)  {
        let parameters = [
            UnsplashResources.Parameters.query : query,
            UnsplashResources.Parameters.page : "\(1)",
            UnsplashResources.Parameters.perPage : "\(30)"
        ]
        
        let url = createQueryURL(path: UnsplashResources.URLSettings.searchPhotosPath, params: parameters)
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = createHeader()
        request.httpMethod = HTTPMethod.get
        
        getURLSession(with: request, completionHandler: completion)
       
    }
    
    private func createQueryURL(path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = UnsplashResources.URLSettings.scheme
        components.host = UnsplashResources.URLSettings.host
        components.path = path
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    private func createHeader() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID \(R.IDs.unsplashAuthID)"
        return headers
    }
    
    
}
