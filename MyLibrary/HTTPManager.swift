//
//  HTTPManager.swift
//  MyLibrary
//
//  Created by Ken Tai on 2022/11/24.
//

import Foundation

class HTTPManager {
    
    static var shared : HTTPManager {
        let instance = HTTPManager()
        // setup code
        return instance
    }
    
    func getBookData(completion:  @escaping (NSMutableArray) -> () ) {
        
        let url = URL(string: "https://mservice.ebook.hyread.com.tw/exam/user-list")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
                    let arrData = NSMutableArray(array:json!)
                    completion(arrData)
                } catch  {
                    print(error)
                }
            }
        }.resume()

    }
    
}
