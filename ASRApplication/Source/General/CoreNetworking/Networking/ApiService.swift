//
//  EkoApiService.swift
//

import UIKit
import Alamofire
import ObjectMapper
import RxSwift

class ApiService: NSObject {
    
    static var shareInstance: ApiService = {
        let instance = ApiService()
        return instance
    }()
    
    private var _headers: HTTPHeaders = [:]
    var headers: HTTPHeaders {
        set {
            _headers = newValue
        }
        get {
            let headers: HTTPHeaders = [
                "Accept": "application/json",
                "Content-Type": "application/json",
//                Constant.headerAuthToken: AuthService.authToken,
                Constant.headerVersion: Constant.appBuild,
            ]
            return headers
        }
    }
    
    private var alamofireManager: Session = Alamofire.Session.default
    
    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        alamofireManager = Alamofire.Session(configuration: configuration)
    }
    
    func request<T: Mappable>(input: EkoBaseRequest) -> Observable<T> {
        debugPrint("\n------------REQUEST INPUT")
        debugPrint("link: %@", input.url)
        debugPrint("body: %@", input.body ?? "No Body")
        debugPrint("------------ END REQUEST INPUT\n")
        debugPrint("headers: %@", self.headers)
        
        return Observable.create { observer in
            self.alamofireManager.request(input.url, method: input.requestType,
                                          parameters: input.body, encoding: input.encoding, headers: self.headers)
                .validate(statusCode: 200..<500)
                .responseJSON { response in
                    debugPrint("full link url request: %@",response.request?.url ?? "Error")
                    debugPrint("API response: %@", response)
                    
                    switch response.result {
                    case .success(let value):
                        guard let statusCode = response.response?.statusCode else {
                            observer.onError(BaseError.unexpectedError)
                            return
                        }
                        if let object = Mapper<T>().map(JSONObject: value) {
                            observer.onNext(object)
                        } else {
                            guard let object = Mapper<ErrorResponse>().map(JSONObject: value) else {
                                observer.onError(BaseError.httpError(httpCode: statusCode))
                                return
                            }
                            observer.onError(BaseError.apiFailure(error: object))
                        }
                    case .failure:
                        observer.onError(BaseError.networkError)
                    }
                    observer.onCompleted()
                    
            }
            return Disposables.create()
        }
    }
}
