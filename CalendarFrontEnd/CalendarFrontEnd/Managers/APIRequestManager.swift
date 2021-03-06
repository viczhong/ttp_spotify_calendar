//
//  APIRequestManager.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/18/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import Foundation

class APIRequestManager {

    // For mocking with tests
    var defaultSession: MockableURLSession = URLSession(configuration: .default)

    func performDataTask(_ type: RequestType, eventToPost event: Event?, completionHandler completion: @escaping (Data?) -> Void) {
        
        var urlString = "https://desolate-cliffs-10757.herokuapp.com/events/"
        if (type == .Put || type == .Delete), let id = event?.id {
            urlString += "\(id)"
        }
        
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = type.rawValue
        
        if type == .Post || type == .Put {
            guard let event = event else { return }
            do {
                let encodedEvent = try JSONEncoder().encode(event)
                request.httpBody = encodedEvent
            }
            catch {
                print(error.localizedDescription)
            }
        }

        defaultSession.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let data = data {
                completion(data)
            }
        }.resume()
    }
    
    
}
