import UIKit

class RegistrationViewController: UIViewController {

    let backgroundColor = UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1.0)

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "INGRESA LOS\nSIGUINETES DATOS"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameLabel: UILabel = createLabel(text: "Usuario:")
    private let usernameTextField: UITextField = createTextField(placeholder: "Usuario")

    private let passwordLabel: UILabel = createLabel(text: "Contraseña:")
    private let passwordTextField: UITextField = createTextField(placeholder: "Contraseña", isSecure: true)
    
    private let nameLabel: UILabel = createLabel(text: "Nombre:")
    private let nameTextField: UITextField = createTextField(placeholder: "Nombre Completo")

    private let emailLabel: UILabel = createLabel(text: "Correo:")
    private let emailTextField: UITextField = createTextField(placeholder: "Correo Electrónico")

    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Crear", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1.0)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private static func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private static func createTextField(placeholder: String, isSecure: Bool = false) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.isSecureTextEntry = isSecure
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        tf.textColor = .black
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.returnKeyType = .done
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        setupUI()
        setupKeyboardDismiss()
        setupTextFieldDelegates()
    }
    
    private func setupUI() {
        let views = [titleLabel, usernameLabel, usernameTextField, passwordLabel, passwordTextField, nameLabel, nameTextField, emailLabel, emailTextField, createButton, activityIndicator]
        views.forEach { view.addSubview($0) }

        let horizontalPadding: CGFloat = 30
        let verticalSpacing: CGFloat = 20
        let textFieldHeight: CGFloat = 44
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),

            usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            usernameTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),

            passwordLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: verticalSpacing),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            passwordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            nameLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: verticalSpacing),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            nameTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),

            emailLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: verticalSpacing),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            emailTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),

            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.widthAnchor.constraint(equalToConstant: 180),
            createButton.heightAnchor.constraint(equalToConstant: 50),
            
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
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
