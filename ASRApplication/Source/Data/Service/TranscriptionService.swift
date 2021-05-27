//
//  TranscriptionService.swift
//  ASRApplication
//

import Foundation
import RxSwift

class TranscriptionService: AppService {
    var transcriptionRepository: TranscriptionRepository { return RepositoryFactory.transcriptionRepository }
    
    func getTranscription() -> Observable<TranscriptionDto> {
        return transcriptionRepository.getTranscription(options: [:])
    }
}
