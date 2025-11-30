import UIKit

class RegistrationViewController: UIViewController {

    let backgroundColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "INGRESA LOS\nSIGUIENTES DATOS"
        label.textColor = UIColor(red: 16/255, green: 255/255, blue: 144/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Crea tu cuenta para continuar"
        label.textColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameLabel: UILabel = createLabel(text: "Usuario")
    private let usernameTextField: UITextField = createTextField(placeholder: "Ingresa tu usuario", icon: "person.fill")

    private let passwordLabel: UILabel = createLabel(text: "Contraseña")
    private let passwordTextField: UITextField = createTextField(placeholder: "Ingresa tu contraseña", isSecure: true, icon: "lock.fill")
    
    private let nameLabel: UILabel = createLabel(text: "Nombre")
    private let nameTextField: UITextField = createTextField(placeholder: "Nombre completo", icon: "person.text.rectangle.fill")

    private let emailLabel: UILabel = createLabel(text: "Correo Electrónico")
    private let emailTextField: UITextField = createTextField(placeholder: "correo@ejemplo.com", icon: "envelope.fill")

    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Crear Cuenta", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 16/255, green: 255/255, blue: 144/255, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
        button.layer.shadowColor = UIColor(red: 16/255, green: 255/255, blue: 144/255, alpha: 0.5).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 12
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = UIColor(red: 16/255, green: 255/255, blue: 144/255, alpha: 1.0)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private static func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(red: 16/255, green: 255/255, blue: 144/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private static func createTextField(placeholder: String, isSecure: Bool = false, icon: String? = nil) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.isSecureTextEntry = isSecure
        tf.borderStyle = .none
        tf.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
        tf.textColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.returnKeyType = .done
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        // Placeholder color
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1.0)]
        )
        
        // Padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: tf.frame.height))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        // Icon
        if let iconName = icon {
            let iconImageView = UIImageView(image: UIImage(systemName: iconName))
            iconImageView.tintColor = UIColor(red: 16/255, green: 255/255, blue: 144/255, alpha: 1.0)
            iconImageView.frame = CGRect(x: 15, y: 0, width: 20, height: 20)
            iconImageView.contentMode = .scaleAspectFit
            paddingView.addSubview(iconImageView)
            iconImageView.center.y = paddingView.frame.height / 2
        }
        
        // Style
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1.5
        tf.layer.borderColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0).cgColor
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        return tf
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        setupUI()
        setupKeyboardDismiss()
        setupTextFieldDelegates()
        setupKeyboardObservers()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let views = [titleLabel, subtitleLabel, usernameLabel, usernameTextField, passwordLabel, passwordTextField, nameLabel, nameTextField, emailLabel, emailTextField, createButton, activityIndicator]
        views.forEach { contentView.addSubview($0) }

        let horizontalPadding: CGFloat = 24
        let verticalSpacing: CGFloat = 16
        let textFieldHeight: CGFloat = 52
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),

            usernameLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 35),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            usernameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            usernameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            usernameTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),

            passwordLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: verticalSpacing + 4),
            passwordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            passwordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            nameLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: verticalSpacing + 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            nameTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),

            emailLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: verticalSpacing + 4),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            emailTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),

            createButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 35),
            createButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            createButton.heightAnchor.constraint(equalToConstant: 56),
            createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func handleCreate() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Error", message: "Todos los campos son obligatorios")
            return
        }
        
        if !isValidEmail(email) {
            showAlert(title: "Error", message: "El correo electrónico no es válido")
            return
        }
        
        registerUser(username: username, password: password, name: name, email: email)
    }
    
    private func registerUser(username: String, password: String, name: String, email: String) {
        guard let url = URL(string: "http://34.224.27.117/usuario/registrar") else {
            showAlert(title: "Error", message: "URL inválida")
            return
        }
        
        let parameters: [String: Any] = [
            "usuario": username,
            "password": password,
            "nombre": name,
            "correo": email
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            showAlert(title: "Error", message: "Error al procesar los datos")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        activityIndicator.startAnimating()
        createButton.isEnabled = false
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.createButton.isEnabled = true
                
                if let error = error {
                    self?.showAlert(title: "Error", message: "Error de conexión: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self?.showAlert(title: "Error", message: "Respuesta inválida del servidor")
                    return
                }
                
                switch httpResponse.statusCode {
                case 200, 201:
                    if let data = data {
                        self?.handleSuccessResponse(data: data)
                    } else {
                        self?.showSuccessAndDismiss()
                    }
                case 400:
                    self?.showAlert(title: "Error", message: "Datos inválidos. Verifica tu información")
                case 409:
                    self?.showAlert(title: "Error", message: "El usuario o email ya existe")
                case 500:
                    self?.showAlert(title: "Error", message: "Error del servidor. Intenta más tarde")
                default:
                    self?.showAlert(title: "Error", message: "Error desconocido (código: \(httpResponse.statusCode))")
                }
            }
        }
        
        task.resume()
    }
    
    private func handleSuccessResponse(data: Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("Respuesta del servidor: \(json)")
            }
            
            showSuccessAndDismiss()
            
        } catch {
            print("Error al parsear respuesta: \(error)")
            showSuccessAndDismiss()
        }
    }
    
    private func showSuccessAndDismiss() {
        let alert = UIAlertController(title: "¡Éxito!", message: "Cuenta creada exitosamente", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        })
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupTextFieldDelegates() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(red: 16/255, green: 255/255, blue: 144/255, alpha: 1.0).cgColor
        textField.layer.borderWidth = 2.0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0).cgColor
        textField.layer.borderWidth = 1.5
    }
}

struct RegistrationResponse: Codable {
    let success: Bool
    let message: String?
    let user: User?
}

struct User: Codable {
    let id: Int
    let username: String
    let email: String
}
