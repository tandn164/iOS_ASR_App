//
//  TranscriptionController.swift
//  ASRApplication
//

class TranscriptionController: AppController {
    
    var transcription: TranscriptionDto!
    let transcriptionService = ServiceFactory.transcriptionService
    
    func getTranscription() {
        _ = transcriptionService.getTranscription().subscribe(
            onNext: {
                data in
                self.transcription = data
                self.notifyObservers(.vGetTranscriptionSuccess)
            },
            onError: onError
        )
    }
}
