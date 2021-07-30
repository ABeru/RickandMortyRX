//
//  ApiServices.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import Foundation
struct Resource<T> {
    let url: URL?
    let parse: (Data) -> T?
}
final class ApiServices {
    static func load<T>(resource: Resource<T>,completion: @escaping (T?) -> ()) {
       guard let url = resource.url else { return}
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
    
            if let data = data {
                DispatchQueue.main.async {
                    completion(resource.parse(data))
                }
            } else {
                print(err!)
            }
}.resume()
}
}
