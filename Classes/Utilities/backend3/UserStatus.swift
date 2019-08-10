
class UserStatus: NSObject {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func createItems() {

		createItem(name: "Available")
		createItem(name: "Busy")
		createItem(name: "At school")
		createItem(name: "At the movies")
		createItem(name: "At work")
		createItem(name: "Battery about to die")
		createItem(name: "Can't talk now")
		createItem(name: "In a meeting")
		createItem(name: "At the gym")
		createItem(name: "Sleeping")
		createItem(name: "Urgent calls only")
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func createItem(name: String) {

		let object = FObject(path: FUSERSTATUS_PATH)

		object[FUSERSTATUS_NAME] = name

		object.saveInBackground(block: { error in
			if (error != nil) {
				print("UserStatus createItem error: \(error)")
			}
		})
	}
}
