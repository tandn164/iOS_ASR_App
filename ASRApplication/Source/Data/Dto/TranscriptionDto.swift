//
//  TranscriptionDto.swift
//  ASRApplication
//

import Foundation
import SwiftyJSON

class TranscriptionDto: BaseDto {
    var transcript: String
    
    init (transcript: String) {
        self.transcript = transcript
        super.init()
    }
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(transcript, forKey: "transcript")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.transcript = aDecoder.decodeObject(forKey: "transcript") as? String ?? ""
        super.init(coder: aDecoder)
    }
    
    required init(fromJson json: JSON?){
        transcript = json?["transcript"].stringValue ?? ""
        super.init(fromJson: json)
    }
    
    override func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["transcript"] = transcript

        return dictionary
    }
}
