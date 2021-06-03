//
//  ApiServiceManager.swift
//  ContactApp
//
//  Created by Midhunlal M on 14/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import Foundation
import UIKit
import Network

typealias ApiServiceCompletionHandler<T> = ((_ result: T?, _ error: Error?) -> Void)
typealias DownloadImageCompletionHandler = ((_ image: UIImage?) -> Void)

final class ApiServiceManager {
    static let sharedInstance = ApiServiceManager()
    private let monitor = NWPathMonitor()
    
    private init() {
        monitor.pathUpdateHandler = { path in }
        let queue = DispatchQueue(label: "Monitor", qos: .background)
        monitor.start(queue: queue)
    }
    
    func executeRequest<T: Decodable>(with endPoint: String,
                                      testResoucePath: String,
                                      requestBody: Any?,
                                      requestMethod: HTTPMethod,
                                      responseType: T.Type,
                                      completionHandler: @escaping ApiServiceCompletionHandler<T>) {
        if NetworkConstants.shouldMokeApi {
            fetchFromFile(withPath: testResoucePath, responseType: responseType, completionHandler: completionHandler)
        } else {
            fetchFromNetwork(with: endPoint, requestBody: requestBody, requestMethod: requestMethod, responseType: responseType, completionHandler: completionHandler)
        }
    }
    
    func executeImageDownload(_ url: URL, completionHandler: @escaping DownloadImageCompletionHandler) {
        downloadImage(url, completionHandler: completionHandler)
    }
}

private extension ApiServiceManager {
    func fetchFromNetwork<T: Decodable>(with endPoint: String,
                                                      requestBody: Any?,
                                                      requestMethod: HTTPMethod,
                                                      responseType: T.Type,
                                                      completionHandler: @escaping ApiServiceCompletionHandler<T>) {
        let urlString = NetworkConstants.baseUrl + endPoint
        guard let url = URL(string: urlString) else {
            completionHandler(nil, nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let requestBody = requestBody as? [String: Any] {
            request.httpBody = try? JSONSerialization.data(withJSONObject:requestBody)
        }
        
        let urlSession = URLSession.shared.dataTask(with: request) {  [weak self] (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            self?.parseResponse(data, responseType: responseType, completionHandler: completionHandler)
        }
        urlSession.resume()
    }
    
    func fetchFromFile<U: Decodable>(withPath path: String,
                          responseType: U.Type,
                          completionHandler: @escaping ApiServiceCompletionHandler<U>) {
        parseResponse(startMockOperation(with: path), responseType: responseType, completionHandler: completionHandler)
    }
    
    func downloadImage(_ url: URL, completionHandler: @escaping DownloadImageCompletionHandler) {
        let urlSession = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completionHandler(nil)
                return
            }
            if let data = data, let image = UIImage(data: data) {
                completionHandler(image)
            } else {
                completionHandler(nil)
            }
        }
        urlSession.resume()
    }
    
    func startMockOperation(with resourcePath: String) -> Data? {
        guard let mockDataBaseURL = Bundle.main.path(forResource: resourcePath, ofType: "json") else {
            return nil
        }
        let contemt = try? String(contentsOfFile: mockDataBaseURL)
        let data = contemt?.data(using: .utf8)
        return data
    }
    
    func parseResponse<T: Decodable>(_ response: Data?,
                                     responseType: T.Type,
                                     completionHandler: @escaping ApiServiceCompletionHandler<T>) {
        if let data = response, !data.isEmpty {
            do {
                let mappedModel = try JSONDecoder().decode(responseType.self, from: data)
                completionHandler(mappedModel, nil)
            } catch {
                completionHandler(nil, error)
            }
        } else {
            completionHandler(nil, nil)
        }
    }
}
