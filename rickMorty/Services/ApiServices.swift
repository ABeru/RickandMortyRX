//
//  ApiServices.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa
import Reachability
import RxReachability
final class ApiServices {
    static func load<T: Decodable>(url: URL, model: T.Type) -> Observable<T> {
        let subject = PublishSubject<T>()
        AF.request(url).validate().responseDecodable(of: model) { (result) in
            guard let res = result.value else {return}
            subject.onNext(res)
        }
        
        return subject
}
}
