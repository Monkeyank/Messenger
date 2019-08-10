class WelcomeView: UIViewController, LoginPhoneDelegate, LoginEmailDelegate, RegisterEmailDelegate {


	override func viewDidLoad() {

		super.viewDidLoad()
	}


	@IBAction func actionLoginPhone(_ sender: Any) {

		let loginPhoneView = LoginPhoneView()
		loginPhoneView.delegate = self
		let navController = NavigationController(rootViewController: loginPhoneView)
		present(navController, animated: true)
	}

    
	func didLoginPhone() {

		dismiss(animated: true) {
			UserLoggedIn(loginMethod: LOGIN_PHONE)
		}
	}


	@IBAction func actionLoginEmail(_ sender: Any) {

		let loginEmailView = LoginEmailView()
		loginEmailView.delegate = self
		present(loginEmailView, animated: true)
	}


	func didLoginEmail() {

		dismiss(animated: true) {
			UserLoggedIn(loginMethod: LOGIN_EMAIL)
		}
	}


	@IBAction func actionRegisterEmail(_ sender: Any) {

		let registerEmailView = RegisterEmailView()
		registerEmailView.delegate = self
		present(registerEmailView, animated: true)
	}


	func didRegisterUser() {

		dismiss(animated: true) {
			UserLoggedIn(loginMethod: LOGIN_EMAIL)
		}
	}
}
