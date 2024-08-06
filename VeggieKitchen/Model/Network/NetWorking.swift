//
//  NetWorking.swift
//  VeggieKitchen
//
//  Created by julie ryan on 31/07/2024.
//

import Foundation

// Protocole pour URLSessionDataTask, utilisé pour les mocks
protocol URLSessionDataTaskProtocol {
    func resume()
}

// Extension pour rendre URLSessionDataTask conforme au protocole
extension URLSessionDataTask: URLSessionDataTaskProtocol {}
protocol Networking {
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}
extension URLSession: Networking {
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return URLSessionDataTaskProxy(dataTask: self.dataTask(with: url, completionHandler: completion))
    }
}
class URLSessionDataTaskProxy: URLSessionDataTaskProtocol {
   let dataTask: URLSessionDataTask
    
    init(dataTask: URLSessionDataTask) {
        self.dataTask = dataTask
    }
    
    func resume() {
        dataTask.resume()
    }
}
