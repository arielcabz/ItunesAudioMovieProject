//
//  ApiManager.swift
//  Appetiser Code Challenge
//
//  Created by Ariel Dominic Cabanag on 2/5/22.
//

import Foundation
import RxSwift
import ObjectMapper
import Alamofire
import Network
class ApiManager {
    static let instance = ApiManager()
    let monitor = NWPathMonitor()
    var hasDetectedConnection = true
    init() {
        monitor.pathUpdateHandler = { [weak self] pathUpdateHandler in
            guard let wSelf = self else { return }
            if pathUpdateHandler.status == .satisfied {
                wSelf.hasDetectedConnection = true
            } else {
                wSelf.hasDetectedConnection = false
            }
        }
    }
    private var networkManager = NetworkManager()
    
    
    /// Fetches liked track from device memory
    /// - RETURNS: An Observable<TrackListModel>
    func getTrackList() -> Observable<TrackListModel> {
        return networkManager.execute(url: "https://itunes.apple.com/search?term=star&amp;country=au&amp;media=movie&amp;all", method: .get)
    }
}


class NetworkManager {
    /// Excutes request
    /// - Parameter url: ID of the liked track
    /// - Parameter method: HTTP Method
    /// - RETURNS: Observable<T>
    func execute<T: Mappable>(url: String, method: HTTPMethod) -> Observable<T> {
        return Observable.create { observer -> Disposable in
            let request = AF.request(url, method: method)
                .responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        
                        // decode data
                        guard let data = data as? [String: Any], let decoded = T(JSON: data) else {
                            return
                        }
                        // return decoded data
                        observer.onNext(decoded)
                        observer.onCompleted()
                        break
                    case.failure(let error):
                        observer.onError(error)
                        break
                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
