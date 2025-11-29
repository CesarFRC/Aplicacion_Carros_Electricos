import UIKit

class LoginViewController: UIViewController {

    
    private let darkBackground = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
    private let neonGreen = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
    private let lightGray = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    private let cardBackground = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
    
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
        imageView.image = UIImage(systemName: "bolt.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "FULL CHARGE"
        label.textColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 36, weight: .black)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Centro de Carga Eléctrica"
        label.textColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.7)
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 0.3).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 15
        view.layer.shadowOpacity = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userLabel: UILabel = {
        let label = UILabel()
        label.text = "Usuario"
        label.textColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Ingrese su usuario"
        tf.textColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tf.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1.0)
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1.5
        tf.layer.borderColor = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1.0).cgColor
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 44))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        tf.attributedPlaceholder = NSAttributedString(
            string: "Ingrese su usuario",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.4)]
        )
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Contraseña"
        label.textColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Ingrese su contraseña"
        tf.isSecureTextEntry = true
        tf.textColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tf.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1.0)
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1.5
        tf.layer.borderColor = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1.0).cgColor
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 44))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        tf.attributedPlaceholder = NSAttributedString(
            string: "Ingrese su contraseña",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.4)]
        )
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("INICIAR SESIÓN", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        button.layer.shadowColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 0.6).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 12
        button.layer.shadowOpacity = 1.0
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()

    private let separatorLabel: UILabel = {
        let label = UILabel()
        label.text = "o"
        label.textColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.5)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Crear Cuenta Nueva", for: .normal)
        button.setTitleColor(UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0), for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0).cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = darkBackground
        setupUI()
        setupKeyboardDismiss()
    }
    
    
    private func setupUI() {
        view.addSubview(iconImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(inputContainerView)
        view.addSubview(loginButton)
        view.addSubview(separatorLabel)
        view.addSubview(registerButton)
        
        inputContainerView.addSubview(userLabel)
        inputContainerView.addSubview(userTextField)
        inputContainerView.addSubview(passwordLabel)
        inputContainerView.addSubview(passwordTextField)
        
        let horizontalPadding: CGFloat = 30
        let containerPadding: CGFloat = 24
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 60),
            iconImageView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            inputContainerView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            
            userLabel.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: containerPadding),
            userLabel.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: containerPadding),
            
            userTextField.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 8),
            userTextField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: containerPadding),
            userTextField.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -containerPadding),
            userTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordLabel.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 20),
            passwordLabel.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: containerPadding),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: containerPadding),
            passwordTextField.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -containerPadding),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: -containerPadding),
            
            loginButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            loginButton.heightAnchor.constraint(equalToConstant: 56),
            
            separatorLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            separatorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            registerButton.topAnchor.constraint(equalTo: separatorLabel.bottomAnchor, constant: 20),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            registerButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    
    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    
    @objc private func handleLogin() {
        guard let username = userTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showErrorAlert(message: "Por favor ingresa usuario y contraseña")
            return
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.loginButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.loginButton.transform = .identity
            }
        }
        
        loginButton.isEnabled = false
        loginButton.alpha = 0.6
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.performLoginSuccess()
        }
    }
    
    private func performLoginSuccess() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0.0
            self.loginButton.layer.shadowRadius = 30
            self.loginButton.layer.shadowOpacity = 1.0
        }) { _ in
            self.transitionToFeedViewController()
        }
    }
    
    private func transitionToFeedViewController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            return
        }
        
        let feedVC = FeedViewController()
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = feedVC
        }) { _ in
            self.view.alpha = 1.0
            self.loginButton.isEnabled = true
            self.loginButton.alpha = 1.0
            self.loginButton.layer.shadowRadius = 12
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        
        loginButton.isEnabled = true
        loginButton.alpha = 1.0
    }
    
    @objc private func handleRegister() {
        UIView.animate(withDuration: 0.1, animations: {
            self.registerButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.registerButton.transform = .identity
            }
        }
        
        let registrationVC = RegistrationViewController()
        registrationVC.modalPresentationStyle = .fullScreen
        registrationVC.modalTransitionStyle = .coverVertical
        
        present(registrationVC, animated: true, completion: nil)
    }
}
