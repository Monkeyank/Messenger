class DBBlocker: RLMObject {

	@objc var objectId = ""

	@objc var blockerId = ""
	@objc var isDeleted = false

	@objc var createdAt: Int64 = 0
	@objc var updatedAt: Int64 = 0


	class func lastUpdatedAt() -> Int64 {

		let dbblocker = DBBlocker.allObjects().sortedResults(usingKeyPath: "updatedAt", ascending: true).lastObject() as? DBBlocker
		return dbblocker?.updatedAt ?? 0
	}


	override static func primaryKey() -> String? {

		return FBLOCKER_OBJECTID
	}
}
