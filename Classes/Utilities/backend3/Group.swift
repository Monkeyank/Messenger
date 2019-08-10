
class Group: NSObject {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func createItem(name: String, picture: String, members: [String], completion: @escaping (_ error: Error?) -> Void) {

		var array = members
		if (array.contains(FUser.currentId()) == false) {
			array.append(FUser.currentId())
		}

		let object = FObject(path: FGROUP_PATH)

		object[FGROUP_USERID] = FUser.currentId()
		object[FGROUP_NAME] = name
		object[FGROUP_PICTURE] = picture
		object[FGROUP_MEMBERS] = array
		object[FGROUP_ISDELETED] = false

		object.saveInBackground(block: { error in
			if (error == nil) {
				deployMembers(members: members)
			}
			completion(error)
		})
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func updateName(groupId: String, name: String, completion: @escaping (_ error: Error?) -> Void) {

		let object = FObject(path: FGROUP_PATH)

		object[FGROUP_OBJECTID] = groupId
		object[FGROUP_NAME] = name

		object.updateInBackground(block: { error in
			completion(error)
		})
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func updatePicture(groupId: String, picture: String, completion: @escaping (_ error: Error?) -> Void) {

		let object = FObject(path: FGROUP_PATH)

		object[FGROUP_OBJECTID] = groupId
		object[FGROUP_PICTURE] = picture

		object.updateInBackground(block: { error in
			completion(error)
		})
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func updateMembers(groupId: String, members: [String], completion: @escaping (_ error: Error?) -> Void) {

		let object = FObject(path: FGROUP_PATH)

		object[FGROUP_OBJECTID] = groupId
		object[FGROUP_MEMBERS] = members

		object.updateInBackground(block: { error in
			if (error == nil) {
				deployMembers(members: members)
			}
			completion(error)
		})
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func deleteItem(groupId: String, completion: @escaping (_ error: Error?) -> Void) {

		let object = FObject(path: FGROUP_PATH)

		object[FGROUP_OBJECTID] = groupId
		object[FGROUP_ISDELETED] = true

		object.updateInBackground(block: { error in
			completion(error)
		})
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func deployMembers(members: [String]) {

		let currentId = FUser.currentId()

		for userId1 in members {
			if (userId1 != currentId) {
				for userId2 in members {
					if (userId2 != userId1) {
						LinkedId.createItem(userId1: userId1, userId2: userId2)
					}
				}
			}
		}
	}
}
