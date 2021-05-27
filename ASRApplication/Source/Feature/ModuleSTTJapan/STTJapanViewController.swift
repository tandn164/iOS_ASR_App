//
//  STTJapanViewController.swift
//  CleanArchitectureBase
//

import UIKit

class STTJapanViewController: AppViewController {
    
    var transcriptionController: TranscriptionController!

    override func viewDidLoad() {
        super.viewDidLoad()
        transcriptionController = ControllerFactory.createController(type: TranscriptionController.self, for: self)
        transcriptionController.notifier.addObserver(self)
        transcriptionController.getTranscription()
    }
    
    override func update(_ command: Command, data: Any?) {
        switch command {
        case .vGetTranscriptionSuccess:
            print(123, transcriptionController.transcription.transcript)
        default:
            super.update(command, data: data)
        }
    }
}
