//
//	Global.swift
//

import Foundation
import SwiftyJSON

class GlobalDto: SocketDataDto {
    var balance: Int!
    var balance2: Int!
    var exp: Int!
    var level: Int!
    var notificationCount: Int!
    var newMessageCount: Int!
    var newRequestCount: Int!
    var newsCount: Int!
    var updatesCount: Int!
    var homeNewsCount: Int!
    var exploreNewsCount: Int!
    var newTrophyCount: Int!
    var fanNewsCount: Int!

    override init () {
        self.balance = 0
        self.balance2 = 0
        self.exp = 0
        self.level = 0
        self.notificationCount = 0
        self.newMessageCount = 0
        self.newRequestCount = 0
        self.newsCount = 0
        self.updatesCount = 0
        self.homeNewsCount = 0
        self.exploreNewsCount = 0
        self.newTrophyCount = 0
        self.fanNewsCount = 0
        super.init()
    }
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(balance, forKey: "balance")
        aCoder.encode(balance2, forKey: "balance2")
        aCoder.encode(exp, forKey: "exp")
        aCoder.encode(level, forKey: "level")
        aCoder.encode(notificationCount, forKey: "notificationCount")
        aCoder.encode(newMessageCount, forKey: "newMessageCount")
        aCoder.encode(newRequestCount, forKey: "newRequestCount")
        aCoder.encode(newsCount, forKey: "newsCount")
        aCoder.encode(updatesCount, forKey: "updatesCount")
        aCoder.encode(homeNewsCount, forKey: "homeNewsCount")
        aCoder.encode(exploreNewsCount, forKey: "exploreNewsCount")
        aCoder.encode(newTrophyCount, forKey: "newTrophyCount")
        aCoder.encode(fanNewsCount, forKey: "fanNewsCount")
    }

    public required init?(coder aDecoder: NSCoder) {
        self.balance = aDecoder.decodeInteger(forKey: "balance")
        self.balance2 = aDecoder.decodeInteger(forKey: "balance2")
        self.exp = aDecoder.decodeInteger(forKey: "exp")
        self.level = aDecoder.decodeInteger(forKey: "level")
        self.notificationCount = aDecoder.decodeInteger(forKey: "notificationCount")
        self.newMessageCount = aDecoder.decodeInteger(forKey: "newMessageCount")
        self.newRequestCount = aDecoder.decodeInteger(forKey: "newRequestCount")
        self.newsCount = aDecoder.decodeInteger(forKey: "newsCount")
        self.updatesCount = aDecoder.decodeInteger(forKey: "updatesCount")
        self.homeNewsCount = aDecoder.decodeInteger(forKey: "homeNewsCount")
        self.exploreNewsCount = aDecoder.decodeInteger(forKey: "exploreNewsCount")
        self.newTrophyCount = aDecoder.decodeInteger(forKey: "newTrophyCount")
        self.fanNewsCount = aDecoder.decodeInteger(forKey: "fanNewsCount")
        super.init(coder: aDecoder)
    }

    required init(fromJson json: JSON!){
        balance = json["balance"].intValue
        balance2 = json["balance2"].intValue
        exp = json["exp"].intValue
        level = json["level"].intValue
        notificationCount = json["notificationCount"].intValue
        newMessageCount = json["newMessageCount"].intValue
        newRequestCount = json["newRequestCount"].intValue
        newsCount = json["newsCount"].intValue
        updatesCount = json["updatesCount"].intValue
        homeNewsCount = json["homeNewsCount"].intValue
        exploreNewsCount = json["exploreNewsCount"].intValue
        newTrophyCount = json["newTrophyCount"].intValue
        fanNewsCount = json["fanNewsCount"].intValue
        super.init(fromJson: json)
    }

    override func toDictionary() -> [String: Any] {
        var dictionary = super.toDictionary()
        dictionary["balance"] = balance
        dictionary["balance2"] = balance2
        dictionary["exp"] = exp
        dictionary["level"] = level
        dictionary["notificationCount"] = notificationCount
        dictionary["newMessageCount"] = newMessageCount
        dictionary["newRequestCount"] = newRequestCount
        dictionary["newsCount"] = newsCount
        dictionary["updatesCount"] = updatesCount
        dictionary["homeNewsCount"] = homeNewsCount
        dictionary["exploreNewsCount"] = exploreNewsCount
        dictionary["newTrophyCount"] = newTrophyCount
        dictionary["fanNewsCount"] = fanNewsCount
        return dictionary
    }
}


extension GlobalDto {
    func load(from prefs: UserDefaults) {
        balance = prefs.integer(forKey: "balance")
        balance2 = prefs.integer(forKey: "balance2")
        exp = prefs.integer(forKey: "exp")
        level = prefs.integer(forKey: "level")
        notificationCount = prefs.integer(forKey: "notificationCount")
        newMessageCount = prefs.integer(forKey: "newMessageCount")
        newRequestCount = prefs.integer(forKey: "newRequestCount")
        newsCount = prefs.integer(forKey: "newsCount")
        updatesCount = prefs.integer(forKey: "updatesCount")
        homeNewsCount = prefs.integer(forKey: "homeNewsCount")
        exploreNewsCount = prefs.integer(forKey: "exploreNewsCount")
        newTrophyCount = prefs.integer(forKey: "newTrophyCount")
        fanNewsCount = prefs.integer(forKey: "fanNewsCount")
    }
    
    func save(to prefs: UserDefaults) {
        prefs.set(balance, forKey: "balance")
        prefs.set(balance2, forKey: "balance2")
        prefs.set(exp, forKey: "exp")
        prefs.set(level, forKey: "level")
        prefs.set(notificationCount, forKey: "notificationCount")
        prefs.set(newMessageCount, forKey: "newMessageCount")
        prefs.set(newRequestCount, forKey: "newRequestCount")
        prefs.set(newsCount, forKey: "newsCount")
        prefs.set(updatesCount, forKey: "updatesCount")
        prefs.set(homeNewsCount, forKey: "homeNewsCount")
        prefs.set(exploreNewsCount, forKey: "exploreNewsCount")
        prefs.set(newTrophyCount, forKey: "newTrophyCount")
        prefs.set(fanNewsCount, forKey: "fanNewsCount")
    }
}
