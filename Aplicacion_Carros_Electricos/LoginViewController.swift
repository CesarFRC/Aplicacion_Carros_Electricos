//
//  ViewController.swift
//  Aplicacion_Carros_Electricos
//
//  Created by donlike on 26/11/25.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Propiedades de la UI (Declaración de Componentes)

    // Fondo verde menta
    let backgroundColor = UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1.0)
    
    // Label de título "¡BIENVENIDO! FULL CHARGE"
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "¡BIENVENIDO!\nFULL CHARGE"
        label.textColor = .black // El color en tu diseño es muy oscuro, lo dejaré en negro para mejor legibilidad.
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .left // Alineado a la izquierda
        label.translatesAutoresizingMaskIntoConstraints = false // Esencial para Auto Layout programático
        return label
    }()
    
    // Label e Input para Usuario
    private let userLabel: UILabel = {
        let label = UILabel()
        label.text = "Ingrese su usuario:"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Usuario"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white // Fondo blanco para el input
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    // Label e Input para Contraseña
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Ingrese su contraseña:"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Contraseña"
        tf.isSecureTextEntry = true // Para ocultar la contraseña
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    // Botón de INICIAR SECCION
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("INICIAR SECCION", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear // Transparente
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 8 // Bordes redondeados sutiles
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        // Agrega una acción (debes implementarla)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()

    // Botón de crear cuenta (amarillo)
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("crear cuenta", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0) // Amarillo brillante
        button.layer.cornerRadius = 20 // Bordes muy redondeados para el estilo
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        // Agrega una acción (para ir a la siguiente pantalla)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()

    // MARK: - Ciclo de Vida de la Vista
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        setupUI()
    }
    
    // MARK: - Configuración de la UI y Constraints
    
    private func setupUI() {
        // 1. Agregar todos los subviews
        view.addSubview(titleLabel)
        view.addSubview(userLabel)
        view.addSubview(userTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)

        // 2. Definir las Constraints (Auto Layout)
        
        // Espacio para la izquierda (padding)
        let horizontalPadding: CGFloat = 30
        
        NSLayoutConstraint.activate([
            // Título: Arriba y a la Izquierda
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),

            // Label de Usuario: Debajo del Título
            userLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            userLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),

            // Text Field de Usuario: Debajo del Label de Usuario
            userTextField.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 8),
            userTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            userTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            userTextField.heightAnchor.constraint(equalToConstant: 44),

            // Label de Contraseña: Debajo del Text Field de Usuario
            passwordLabel.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 20),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),

            // Text Field de Contraseña: Debajo del Label de Contraseña
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Botón INICIAR SECCION: Debajo de los inputs
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 180), // Ancho fijo
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Botón crear cuenta: Cerca de la parte inferior
            registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 180), // Ancho fijo
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Acciones (Ejemplo de Navegación)
    
    @objc private func handleLogin() {
        print("Intentando iniciar sesión con: \(userTextField.text ?? "")")
        // Aquí iría la lógica de autenticación
    }
    
    @objc private func handleRegister() {
        // Navegar a la pantalla de Registro
        let registrationVC = RegistrationViewController()
        registrationVC.modalPresentationStyle = .fullScreen
        present(registrationVC, animated: true, completion: nil)
    }
}

