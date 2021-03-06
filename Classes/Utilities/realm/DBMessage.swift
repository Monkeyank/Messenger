class DBMessage: RLMObject {

	@objc dynamic var objectId = ""

	@objc dynamic var chatId = ""
	@objc dynamic var members = ""

	@objc dynamic var senderId = ""
	@objc dynamic var senderName = ""
	@objc dynamic var senderInitials = ""
	@objc dynamic var senderPicture = ""

	@objc dynamic var recipientId = ""
	@objc dynamic var recipientName = ""
	@objc dynamic var recipientInitials = ""
	@objc dynamic var recipientPicture = ""

	@objc dynamic var groupId = ""
	@objc dynamic var groupName = ""
	@objc dynamic var groupPicture = ""

	@objc dynamic var type = ""
	@objc dynamic var text = ""

	@objc dynamic var picture = ""
	@objc dynamic var pictureWidth: Int = 0
	@objc dynamic var pictureHeight: Int = 0
	@objc dynamic var pictureMD5 = ""

	@objc dynamic var video = ""
	@objc dynamic var videoDuration: Int = 0
	@objc dynamic var videoMD5 = ""

	@objc dynamic var audio = ""
	@objc dynamic var audioDuration: Int = 0
	@objc dynamic var audioMD5 = ""

	@objc dynamic var latitude: CLLocationDegrees = 0
	@objc dynamic var longitude: CLLocationDegrees = 0

	@objc dynamic var status = ""
	@objc dynamic var isDeleted = false

	@objc dynamic var createdAt: Int64 = 0
	@objc dynamic var updatedAt: Int64 = 0

    
	class func lastUpdatedAt() -> Int64 {

		let dbmessage = DBMessage.allObjects().sortedResults(usingKeyPath: "updatedAt", ascending: true).lastObject() as? DBMessage
		return dbmessage?.updatedAt ?? 0
	}


	override static func primaryKey() -> String? {

		return FMESSAGE_OBJECTID
	}
}
