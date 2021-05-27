//
//  Config.swift
//

import Foundation

import SwiftyJSON

class AppConfig {
    static var schema = "excluslive"

    static var socketServer = ""
//    static var server = "https://asrbackend-3f0b2.web.app/"
    static var server = "http://localhost:5000/"
    static var streamServer = ""

    static var debug = false
    static var webServer = ""
    static var useMockResponse: Bool {
        return AppConfig.debug
    }
    
    static let storyboardName = "Main"
    static let itemPerPage = 20
    static let localStorageVersion = 3 // 1 for first version

    static func initialize() {
#if DEBUG
    let json = JSON(parseJSON: Util.readTextFile(name: "dev", type: "json"))
        let devConfig = DevConfig(fromJson: json)
        if let debug = devConfig.debug {
            AppConfig.debug = debug
        }
        if AppConfig.debug {
            AppConfig.server = devConfig.server
            AppConfig.streamServer = devConfig.streamServer
            AppConfig.webServer = devConfig.webServer
        }
#endif
    }
}


class DevConfig: NSObject, NSCoding {
    var debug: Bool!
    var server: String
    var streamServer: String
    var webServer: String
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(debug, forKey: "debug")
        aCoder.encode(server, forKey: "server")
        aCoder.encode(streamServer, forKey: "streamServer")
        aCoder.encode(webServer, forKey: "webServer")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.debug = aDecoder.decodeBool(forKey: "debug")
        self.server = aDecoder.decodeObject(forKey: "server") as! String
        self.streamServer = aDecoder.decodeObject(forKey: "streamServer") as! String
        self.webServer = aDecoder.decodeObject(forKey: "webServer") as! String
        super.init()
    }
    
    required init(fromJson json: JSON!){
        if json["debug"] != JSON.null {
            debug = json["debug"].boolValue
        }
        server = json["server"].stringValue
        streamServer = json["streamServer"].stringValue
        webServer = json["webServer"].stringValue
        super.init()
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["debug"] = debug
        dictionary["server"] = server
        dictionary["streamServer"] = streamServer
        dictionary["webServer"] = webServer
        return dictionary
    }
}
