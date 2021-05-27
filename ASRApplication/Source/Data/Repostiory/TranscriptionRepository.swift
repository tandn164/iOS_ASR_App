//
//  TranscriptionRepository.swift
//  ASRApplication
//

import Foundation
import RxSwift

class TranscriptionRepository: AppRemoteRepository<TranscriptionDto> {
    let transcriptionRequest = RequestFactory.transcriptionRequest
    init() {
        super.init(request: transcriptionRequest)
    }
    
    func getTranscription(options: [String: Any]) -> Observable<TranscriptionDto> {
        return transcriptionRequest.getTranscription(options: options)
            .map({(response: HttpResponse) -> TranscriptionDto in
                let object = TranscriptionDto(fromJson: response.data)
                return object
            })
    }
}
