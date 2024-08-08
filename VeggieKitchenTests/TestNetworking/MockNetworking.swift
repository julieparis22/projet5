//
//  MockNetworking.swift
//  VeggieKitchenTests
//
//  Created by julie ryan on 31/07/2024.
//

import Foundation


@testable import VeggieKitchen


class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let resumeHandler: () -> Void
    
    init(resumeHandler: @escaping () -> Void) {
        self.resumeHandler = resumeHandler
    }
    
    func resume() {
        resumeHandler()
    }
}

class MockNetworking: Networking {
    private let mockData: Data?
    private let mockError: Error?
    
    init(mockData: Data? = nil, mockError: Error? = nil) {
        self.mockData = mockData
        self.mockError = mockError
    }
    
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return MockURLSessionDataTask {
            completion(self.mockData, nil, self.mockError)
        }
    }
}
