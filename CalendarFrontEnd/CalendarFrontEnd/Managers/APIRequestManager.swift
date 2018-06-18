//
//  APIRequestManager.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/18/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import Foundation

class APIRequestManager {

    func performDataTask(_ type: RequestType, events: [Event]?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {

        guard let url = URL(string: "Heroku URL Here") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue

        if type == .post {
            //TODO: - ADD STUFF HERE
        }

        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(nil, nil, error)
            }

            if let data = data {
                completionHandler(data, nil, nil)
            }
        }.resume()
    }


}
