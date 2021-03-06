class FObject: NSObject {

	private var pathX: String!
	private var subpathX: String?
	var values: [String: Any] = [:]


	init(path: String, subpath: String?) {

		super.init()

		pathX = path
		subpathX = subpath
	}

	
	convenience init(path: String) {

		self.init(path: path, subpath: nil)
	}

	convenience init(path: String, dictionary: [String: Any]) {

		self.init(path: path, subpath: nil, dictionary: dictionary)
	}

	
	convenience init(path: String, subpath: String?, dictionary: [String: Any]) {

		self.init(path: path, subpath: subpath)

		for (key, value) in dictionary {
			values[key] = value
		}
	}


	subscript(key: String) -> Any? {

		get {
			return values[key]
		}
		set {
			values[key] = newValue
		}
	}

	
	func objectId() -> String {

		return values["objectId"] as! String
	}

	
	func objectIdInit() {

		if (values["objectId"] == nil) {
			let reference = databaseReference()
			values["objectId"] = reference.key
		}
	}

	
	func saveInBackground() {

		let reference = databaseReference()

		if (values["objectId"] == nil) {
			values["objectId"] = reference.key
		}

		if (values["createdAt"] == nil) {
			values["createdAt"] = ServerValue.timestamp()
		}

		values["updatedAt"] = ServerValue.timestamp()

		reference.updateChildValues(values)
	}

	
	func saveInBackground(block: @escaping (_ error: Error?) -> Void) {

		let reference = databaseReference()

		if (values["objectId"] == nil) {
			values["objectId"] = reference.key
		}

		if (values["createdAt"] == nil) {
			values["createdAt"] = ServerValue.timestamp()
		}

		values["updatedAt"] = ServerValue.timestamp()

		reference.updateChildValues(values, withCompletionBlock: { error, ref in
			block(error)
		})
	}

	
	func updateInBackground() {

		if (values["objectId"] != nil) {
			values["updatedAt"] = ServerValue.timestamp()

			let reference = databaseReference()
			reference.updateChildValues(values)
		}
	}

	
	func updateInBackground(block: @escaping (_ error: Error?) -> Void) {

		if (values["objectId"] != nil) {
			values["updatedAt"] = ServerValue.timestamp()

			let reference = databaseReference()
			reference.updateChildValues(values, withCompletionBlock: { error, ref in
				block(error)
			})
		} else {
			block(NSError.description("Object cannot be updated.", code: 101))
		}
	}

	
	func deleteInBackground() {

		if (values["objectId"] != nil) {
			let reference = databaseReference()
			reference.removeValue()
		}
	}

	
	func deleteInBackground(block: @escaping (_ error: Error?) -> Void) {

		if (values["objectId"] != nil) {
			let reference = databaseReference()
			reference.removeValue(completionBlock: { error, ref in
				block(error)
			})
		} else {
			block(NSError.description("Object cannot be deleted.", code: 102))
		}
	}

	
	func fetchInBackground() {

		let reference = databaseReference()
		reference.observeSingleEvent(of: DataEventType.value, with: { snapshot in
			if (snapshot.exists()) {
				self.values = snapshot.value as! [String: Any]
			}
		})
	}

	
	func fetchInBackground(block: @escaping (_ error: Error?) -> Void) {

		let reference = databaseReference()
		reference.observeSingleEvent(of: DataEventType.value, with: { snapshot in
			if (snapshot.exists()) {
				self.values = snapshot.value as! [String: Any]
				block(nil)
			} else {
				block(NSError.description("Object not found.", code: 103))
			}
		})
	}

	
	func databaseReference() -> DatabaseReference {

		var reference: DatabaseReference!

		if (subpathX == nil) {
			reference = Database.database().reference(withPath: pathX)
		} else {
			reference = Database.database().reference(withPath: pathX).child(subpathX!)
		}

		if (values["objectId"] == nil) {
			return reference.childByAutoId()
		} else {
			let objectId = values["objectId"] as! String
			return reference.child(objectId)
		}
	}
}
