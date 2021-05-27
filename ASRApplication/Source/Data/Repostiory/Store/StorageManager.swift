//
//  StorageManager.swift
//

import Foundation

public class StorageManager {
//    static let userStorage = UserStorage(DbConnection.instance.db)

    public static func initialize() {
        var storages: [Storage] = []
//        storages.append(StorageManager.userStorage)

        var currentVersion = DbConnection.instance.db.userVersion
        if (currentVersion == 0 && Constant.appIdentifier == "com.sotatek.excluslive") {
            // support migrate first version of ExclusLive
            currentVersion = 1
        }
        let newVersion = AppConfig.localStorageVersion

        if (currentVersion > 0) {
            // Only migrate if user has installed older version
            for i in currentVersion..<newVersion {
                for storage in storages {
                    storage.migrate(fromVersion: i, toVersion: i + 1)
                }
            }
        }
        DbConnection.instance.db.userVersion = newVersion
    }
}
