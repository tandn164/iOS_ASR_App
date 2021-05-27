//DbConnection.swift

import Foundation
import SQLite

public class DbConnection {
    public static let instance = DbConnection()
    
    public var db = try! Connection()
    
    private init () {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        db = try! Connection("\(path)/db.sqlite3")
    }
}

extension Connection {
    public var userVersion: Int {
        get { return Int(try! scalar("PRAGMA user_version") as! Int64)}
        set { try! run("PRAGMA user_version = \(newValue)") }
    }
}
