//
//  Meta.swift
//

import Foundation
import ObjectMapper

public final class MetaResponse: Mappable, NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let code = "code"
    static let serverTime = "serverTime"
    static let masterdataVersion = "masterdataVersion"
  }

  // MARK: Properties
  public var code: Int?
  public var serverTime: Int?
  public var masterdataVersion: Int?

  // MARK: ObjectMapper Initializers
  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.
  public required init?(map: Map){

  }

  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.
  public func mapping(map: Map) {
    code <- map[SerializationKeys.code]
    serverTime <- map[SerializationKeys.serverTime]
    masterdataVersion <- map[SerializationKeys.masterdataVersion]
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = code { dictionary[SerializationKeys.code] = value }
    if let value = serverTime { dictionary[SerializationKeys.serverTime] = value }
    if let value = masterdataVersion { dictionary[SerializationKeys.masterdataVersion] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.code = aDecoder.decodeObject(forKey: SerializationKeys.code) as? Int
    self.serverTime = aDecoder.decodeObject(forKey: SerializationKeys.serverTime) as? Int
    self.masterdataVersion = aDecoder.decodeObject(forKey: SerializationKeys.masterdataVersion) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(code, forKey: SerializationKeys.code)
    aCoder.encode(serverTime, forKey: SerializationKeys.serverTime)
    aCoder.encode(masterdataVersion, forKey: SerializationKeys.masterdataVersion)
  }

}
