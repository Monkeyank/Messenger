
class CallHistories: NSObject {

	private var timer: Timer?
	private var refreshUICallHistories = false
	private var firebase: DatabaseReference?

	//---------------------------------------------------------------------------------------------------------------------------------------------
	static let shared: CallHistories = {
		let instance = CallHistories()
		return instance
	} ()

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override init() {

		super.init()

		NotificationCenterX.addObserver(target: self, selector: #selector(initObservers), name: NOTIFICATION_APP_STARTED)
		NotificationCenterX.addObserver(target: self, selector: #selector(initObservers), name: NOTIFICATION_USER_LOGGED_IN)
		NotificationCenterX.addObserver(target: self, selector: #selector(actionCleanup), name: NOTIFICATION_USER_LOGGED_OUT)

		timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(refreshUserInterface), userInfo: nil, repeats: true)
	}

	// MARK: - Backend methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func initObservers() {

		if (FUser.currentId() != "") {
			if (firebase == nil) {
				createObservers()
			}
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func createObservers() {

		let lastUpdatedAt = DBCallHistory.lastUpdatedAt()

		firebase = Database.database().reference(withPath: FCALLHISTORY_PATH).child(FUser.currentId())
		let query = firebase?.queryOrdered(byChild: FCALLHISTORY_UPDATEDAT).queryStarting(atValue: lastUpdatedAt + 1)

		query?.observe(DataEventType.childAdded, with: { snapshot in
			let callHistory = snapshot.value as! [String: Any]
			if (callHistory[FCALLHISTORY_CREATEDAT] as? Int64 != nil) {
				DispatchQueue(label: "CallHistories").async {
					self.updateRealm(callHistory: callHistory)
					self.refreshUICallHistories = true
				}
			}
		})

		query?.observe(DataEventType.childChanged, with: { snapshot in
			let callHistory = snapshot.value as! [String: Any]
			if (callHistory[FCALLHISTORY_CREATEDAT] as? Int64 != nil) {
				DispatchQueue(label: "CallHistories").async {
					self.updateRealm(callHistory: callHistory)
					self.refreshUICallHistories = true
				}
			}
		})
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func updateRealm(callHistory: [String: Any]) {

		do {
			let realm = RLMRealm.default()
			realm.beginWriteTransaction()
			DBCallHistory.createOrUpdate(in: realm, withValue: callHistory)
			try realm.commitWriteTransaction()
		} catch {
			ProgressHUD.showError("Realm commit error.")
		}
	}

	// MARK: - Cleanup methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionCleanup() {

		firebase?.removeAllObservers()
		firebase = nil
	}

	// MARK: - Notification methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func refreshUserInterface() {

		if (refreshUICallHistories) {
			NotificationCenterX.post(notification: NOTIFICATION_REFRESH_CALLHISTORIES)
			refreshUICallHistories = false
		}
	}
}
