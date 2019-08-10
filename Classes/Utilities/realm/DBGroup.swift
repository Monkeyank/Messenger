class DBGroup: RLMObject {

	@objc dynamic var objectId = ""

	@objc dynamic var userId = ""
	@objc dynamic var name = ""
	@objc dynamic var picture = ""
	@objc dynamic var members = ""

	@objc dynamic var isDeleted = false

	@objc dynamic var createdAt: Int64 = 0
	@objc dynamic var updatedAt: Int64 = 0


	class func lastUpdatedAt() -> Int64 {

		let dbgroup = DBGroup.allObjects().sortedResults(usingKeyPath: "updatedAt", ascending: true).lastObject() as? DBGroup
		return dbgroup?.updatedAt ?? 0
	}


	override static func primaryKey() -> String? {

		return FGROUP_OBJECTID
	}
}
