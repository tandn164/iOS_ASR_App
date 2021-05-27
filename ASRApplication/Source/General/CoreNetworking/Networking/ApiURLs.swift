//ApiURLs.swift

import Foundation

struct BaseApiURLs {
    static let APIBaseUrl = AppConfig.server
}

struct ActorsURL {
    static let getMyActorProfile = BaseApiURLs.APIBaseUrl + "myActorProfile"
    static let createMediaGroup = BaseApiURLs.APIBaseUrl + "mediaGroup"
    static let createMediaSingle = BaseApiURLs.APIBaseUrl + "mediaSingle"
}
