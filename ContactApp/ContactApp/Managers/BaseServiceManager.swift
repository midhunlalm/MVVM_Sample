//
//  BaseServiceManager.swift
//  ContactApp
//
//  Created by Midhunlal M on 14/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import Foundation

typealias baseResponse = (Any?, Error?) -> Void

class BaseServiceManager {
    private static let apiServiceManager = ApiServiceManager.sharedInstance
    
    fileprivate static func executeRequest<T: Decodable>(with endPoint: String,
                                                         testResoucePath: String,
                                                         requestBody: [String:Any]? = nil,
                                                         requestMethod: HTTPMethod,
                                                         responseType: T.Type,
                                                         completionHandler: @escaping ApiServiceCompletionHandler<T>) {
        
        apiServiceManager.executeRequest(with: endPoint, testResoucePath: testResoucePath, requestBody: requestBody, requestMethod: requestMethod, responseType: responseType) { (response, error) in
            DispatchQueue.main.async {
                completionHandler(response, error)
            }
        }
    }
    
    fileprivate static func prepareRequestBody<T: Encodable>(param: T) -> [String:Any]? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        guard let body = try? jsonEncoder.encode(param) else { return nil }
        if let reqBody = try? JSONSerialization.jsonObject(with: body, options: .mutableContainers) as? [String: Any] {
            return reqBody
        }
        return nil
    }
}

extension BaseServiceManager {
    static func fetchContactList(_ completion: @escaping baseResponse) {
        let endPoint = ApiEndPoints.contacts.getEndPoint()
        let testResourcePath = ApiEndPoints.contacts.getTestResourcePath()
        
        executeRequest(with: endPoint, testResoucePath: testResourcePath, requestMethod: .get, responseType: [Contact].self) { (response, error) in
            completion(response, error)
        }
    }
    
    static func fetchContactDetails(for contactId: Int, completion: @escaping baseResponse) {
        let endPoint = String(format: ApiEndPoints.contactDetails.getEndPoint(), contactId)
        let testResourcePath = ApiEndPoints.contactDetails.getTestResourcePath()
        
        executeRequest(with: endPoint, testResoucePath: testResourcePath, requestMethod: .get, responseType: Contact.self) { (response, error) in
            completion(response, error)
        }
    }
    
    static func addContact(withDetails contact: Contact, completion: @escaping baseResponse) {
        let endPoint = ApiEndPoints.addContact.getEndPoint()
        let reqBody = prepareRequestBody(param: contact)
        let testResourcePath = ApiEndPoints.addContact.getTestResourcePath()
        
        executeRequest(with: endPoint, testResoucePath: testResourcePath, requestBody: reqBody,
                       requestMethod: .post, responseType: Contact.self) { (response, error) in
            completion(response, error)
        }
    }
    
    static func updateContactDetails(for contact: Contact, completion: @escaping baseResponse) {
        let endPoint = String(format: ApiEndPoints.updateContact.getEndPoint(), contact.id ?? "")
        let reqBody = prepareRequestBody(param: contact)
        let testResourcePath = ApiEndPoints.updateContact.getTestResourcePath()
        
        executeRequest(with: endPoint, testResoucePath: testResourcePath, requestBody: reqBody,
                       requestMethod: .put, responseType: Contact.self) { (response, error) in
            completion(response, error)
        }
    }
}
