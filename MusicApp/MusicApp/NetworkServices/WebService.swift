//
//  WebService.swift
//  MusicApp
//
//  Created by Sachin Gupta on 3/9/21.
//

import Foundation
import Combine

enum HttpMethod : String{
    case GET
    case POST
}

struct Resource {
    var url:String
    var httpMethod:HttpMethod
}

struct WebService {
    let urlSession : URLSession
    init(urlSession : URLSession = .shared) {
        self.urlSession = urlSession
    }
    func APIRequest(resource : Resource)->AnyPublisher<Data,Error> {
       
        guard let url = URL(string: resource.url) else {
                let error = URLError(.badURL, userInfo: [NSURLErrorKey: resource.url])
                return Fail(error: error).eraseToAnyPublisher()
            }
        let urlRequest = URLRequest(url:url )
        return urlSession.dataTaskPublisher(for:urlRequest)
            .receive(on: RunLoop.main)
            .tryMap { $0.data }
            .eraseToAnyPublisher()
    }
    
    func downloadImage(for urlString: String, success: @escaping(Data?)->Void, fail:@escaping(Error?)->Void )  {
        guard let url = URL(string: urlString) else {
                let error = URLError(.badURL, userInfo: [NSURLErrorKey: urlString])
                return fail(error)
            }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                success(data)
            }
        }.resume()
    }
    
}


