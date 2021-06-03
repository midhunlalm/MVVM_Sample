//
//  NetworkConstants.swift
//  ContactApp
//
//  Created by Midhunlal M on 14/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import Foundation

// MARK: - Network Constants
struct NetworkConstants {
    private enum WebServiceEnvironment {
        case production
        case staging
        case moke
    }
    private static let environment: WebServiceEnvironment = .staging
    
    static var shouldMokeApi: Bool {
        return environment == .moke
    }
    
    static var baseUrl: String {
        switch NetworkConstants.environment {
        case .production:
            return "http://gojek-contacts-app.herokuapp.com"
        case .staging:
            return "http://gojek-contacts-app.herokuapp.com"
        default:
            return ""
        }
    }
}

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

enum ApiEndPoints {
    case contacts
    case contactDetails
    case addContact
    case updateContact
    
    func getEndPoint() -> String {
        switch self {
        case .contacts, .addContact:
            return "/contacts.json"
        case .contactDetails, .updateContact:
            return "/contacts/%d.json"
        }
    }
    
    func getTestResourcePath() -> String {
        switch self {
        case .contacts:
            return "contacts"
        case .addContact, .contactDetails, .updateContact:
            return "contactDetails"
        }
    }
}
