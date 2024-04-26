//
//  URLSessionManager.swift
//  DemoAPICall
//
//  Created by iMac on 26/04/24.
//

import Foundation

enum BaseUrl: String {
    case devURL = "https://jsonplaceholder.typicode.com/"
}

enum EndPoint: String{
    case posts = "posts"
}

enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
}

// Define a struct to represent the data from the JSONPlaceholder API
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    var additionalDetails: String?
}

class URLSessionManager {
    
    static let shared = URLSessionManager()
    
    // Function to fetch posts with pagination
    func fetchPosts(page: Int, completion: @escaping ([Post]?,Bool,Error?) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts?_page=\(page)")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, false, error)
                return
            }
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                if posts.count == 0 {
                    completion(posts, true, nil)
                } else {
                    completion(posts, false, nil)
                }
                
            } catch {
                completion(nil, false, error)
            }
        }
        task.resume()
    }
}
