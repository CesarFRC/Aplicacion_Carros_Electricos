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
    
    private let usernameLabel: UILabel = createLabel(text: "Nombre de Usuario:")
    private let usernameTextField: UITextField = createTextField(placeholder: "Nombre de Usuario")

    private let passwordLabel: UILabel = createLabel(text: "Contraseña:")
    private let passwordTextField: UITextField = createTextField(placeholder: "Contraseña", isSecure: true)

    private let emailLabel: UILabel = createLabel(text: "Correo Electronico:")
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
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        setupUI()
    }
    

    
    private func setupUI() {
        let views = [titleLabel, usernameLabel, usernameTextField, passwordLabel, passwordTextField, emailLabel, emailTextField, createButton]
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

            emailLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: verticalSpacing),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            emailTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),

            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.widthAnchor.constraint(equalToConstant: 180), 
            createButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    
    @objc private func handleCreate() {
        print("Intentando crear cuenta con los datos ingresados.")
        
        dismiss(animated: true, completion: nil)
    }
}
