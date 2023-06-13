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
    enum URL {
        static let scheme = "https"
        static let host = "api.unsplash.com"
        static let randomPhotosPath = "/search/photos"
    }
    static let authID = "BN1-jX1MuvL8gagcdvR7vEaGTbJx9TSRbUsUzV4ltRU"
}

protocol NetworkServiceProtocol {
    func getImages()
}

class NetworkService {
    
    private func getURLSession<T: Decodable>(with urlRequest: URLRequest, completionHandler: @escaping (Result<[T], Error>) -> Void){
        URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            guard let data = data else { return }
            if let error = error{
                completionHandler(.failure(error))
            } else {
                do{
                    let recievedData = try JSONDecoder().decode([T].self, from: data)
                    completionHandler(.success(recievedData))
                } catch {
                    debugPrint(error)
                    completionHandler(.failure(error))
                }
            }
        }.resume()
    }
}

extension NetworkService {
    func getImages(count: Int, completion: @escaping (Result<[PhotoUnsplash], Error>) -> Void)  {
        let parameters = createParaments(count: count)
        let url = createQueryURL(params: parameters)
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = createHeader()
        request.httpMethod = HTTPMethod.get
        
        getURLSession(with: request, completionHandler: completion)
       
    }
    
    private func createQueryURL(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = UnsplashResources.URL.scheme
        components.host = UnsplashResources.URL.host
        components.path = UnsplashResources.URL.randomPhotosPath
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    private func createHeader() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID \(R.IDs.unsplashAuthID)"
        return headers
    }
    
    private func createParaments(count: Int) -> [String: String] {
        var parameters = [String: String]()
        parameters["count"] = "\(count)"
        return parameters
    }
    
}
