import UIKit



class AddVehicleController: UIViewController {

    private static let darkBackground = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
    private static let neonGreen = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
    private static let darkGrayCard = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
    private static let inputBackground = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1.0)

    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "AGREGAR NUEVO VEHÍCULO"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Ingresa los detalles y el ID de la tarjeta de carga."
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Nuevo campo para el ID de la tarjeta que usas como _id en la API
    private let cardIdTextField: UITextField = createTextField(placeholder: "ID de Tarjeta / Número (Ej. 123456)")
    private let brandTextField: UITextField = createTextField(placeholder: "Marca del Vehículo (Ej. Tesla, Nissan)")
    private let modelTextField: UITextField = createTextField(placeholder: "Modelo (Ej. Model 3, Leaf)")
    private let yearTextField: UITextField = createTextField(placeholder: "Año (Ej. 2023)")
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("GUARDAR VEHÍCULO", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = AddVehicleController.neonGreen
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        button.layer.shadowColor = AddVehicleController.neonGreen.withAlphaComponent(0.6).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 12
        button.layer.shadowOpacity = 0.5
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSaveVehicle), for: .touchUpInside)
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = AddVehicleController.neonGreen
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var formStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cardIdTextField, brandTextField, modelTextField, yearTextField])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    
    private static func createTextField(placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tf.backgroundColor = AddVehicleController.inputBackground
        tf.layer.cornerRadius = 8
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(white: 0.2, alpha: 1.0).cgColor
        tf.autocapitalizationType = .sentences
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 44))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 0.7, alpha: 0.5)]
        )
        // Ajustar el tipo de teclado según el contenido
        if placeholder.contains("Año") || placeholder.contains("ID de Tarjeta") {
            tf.keyboardType = .numberPad
        } else {
            tf.keyboardType = .default
        }
        return tf
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AddVehicleController.darkBackground
        setupUI()
        setupKeyboardDismiss()
        yearTextField.delegate = self
    }
    
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(instructionLabel)
        view.addSubview(formStackView)
        view.addSubview(saveButton)
        view.addSubview(activityIndicator)
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = AddVehicleController.neonGreen
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            instructionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            formStackView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 40),
            formStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            formStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            cardIdTextField.heightAnchor.constraint(equalToConstant: 50),
            brandTextField.heightAnchor.constraint(equalToConstant: 50),
            modelTextField.heightAnchor.constraint(equalToConstant: 50),
            yearTextField.heightAnchor.constraint(equalToConstant: 50),
            
            saveButton.topAnchor.constraint(equalTo: formStackView.bottomAnchor, constant: 60),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            saveButton.heightAnchor.constraint(equalToConstant: 56),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor)
        ])
    }

    
    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @objc private func handleSaveVehicle() {
        // 1. Validación y Recolección de datos
        guard let cardId = cardIdTextField.text, !cardId.isEmpty,
              let brand = brandTextField.text, !brand.isEmpty,
              let model = modelTextField.text, !model.isEmpty,
              let yearText = yearTextField.text, let year = Int(yearText) else {
            
            showErrorAlert(message: "Por favor, completa todos los campos correctamente. El Año debe ser numérico.")
            return
        }
        
        // 2. Obtener usuario de sesión
        guard let usuarioId = UserSession.shared.userId else {
            showErrorAlert(message: "Error de sesión. No se pudo obtener el ID del usuario. Por favor, reinicia la aplicación.")
            return
        }
        
        print("Guardando nuevo vehículo (ID Usuario: \(usuarioId))")
        print("Datos de formulario: Tarjeta ID: \(cardId), Marca: \(brand), Modelo: \(model), Año: \(year)")
        
        // 3. Crear el payload
        let parameters: [String: Any] = [
            "_id": cardId,             // El ID de tarjeta que la API usa para buscar la tarjeta
            "usuario_id": usuarioId,  // ID del usuario que registra el vehículo
            "marca": brand,
            "modelo": model,
            "año": year,
            "estado": "libre"         // Estado inicial
        ]
        
        performVehicleRegistration(parameters: parameters)
    }

    private func performVehicleRegistration(parameters: [String: Any]) {
        guard let url = URL(string: "http://34.224.27.117/usuario/registrar-vehiculo") else {
            showErrorAlert(message: "URL de registro inválida.")
            return
        }
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            showErrorAlert(message: "Error al procesar los datos a JSON.")
            return
        }
        
        print("📤 ENVIANDO A REGISTRO: \(String(data: httpBody, encoding: .utf8) ?? "N/A")")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        // Deshabilitar botón e iniciar indicador
        saveButton.isEnabled = false
        saveButton.alpha = 0.6
        activityIndicator.startAnimating()
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.saveButton.isEnabled = true
                self?.saveButton.alpha = 1.0
                self?.activityIndicator.stopAnimating()
                
                if let error = error {
                    print("❌ ERROR DE RED: \(error.localizedDescription)")
                    self?.showErrorAlert(message: "Error de conexión: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ Respuesta no es HTTPURLResponse")
                    self?.showErrorAlert(message: "Respuesta inválida del servidor")
                    return
                }
                
                print("📥 STATUS CODE: \(httpResponse.statusCode)")
                
                guard let data = data else {
                    print("❌ No hay datos en la respuesta")
                    self?.showErrorAlert(message: "No se recibieron datos del servidor")
                    return
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📥 RESPUESTA DEL SERVIDOR: \(responseString)")
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        
                        // Si ok es false, hubo un error de negocio (ej. tarjeta en uso)
                        if let ok = json["ok"] as? Bool, ok == false {
                            let message = json["msg"] as? String ?? "Error desconocido al registrar vehículo."
                            self?.showErrorAlert(message: message)
                            print("❌ ERROR DE NEGOCIO: \(message)")
                            return
                        }
                        
                        // Éxito (status 200/201 y ok: true implícitamente)
                        let successMessage = json["msg"] as? String ?? "Vehículo registrado correctamente."
                        self?.showSuccessAlert(message: successMessage)
                        print("✅ REGISTRO EXITOSO: \(successMessage)")
                        
                        // Cerrar pantalla después de un registro exitoso
                        self?.dismiss(animated: true, completion: nil)
                        
                    } else {
                        self?.showErrorAlert(message: "Respuesta del servidor inválida.")
                    }
                } catch {
                    print("❌ Error al parsear JSON de respuesta: \(error)")
                    self?.showErrorAlert(message: "Error al procesar la respuesta del servidor.")
                }
            }
        }
        task.resume()
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showSuccessAlert(message: String) {
        // En una aplicación real, probablemente solo harías dismiss.
        // Usamos la alerta para confirmar el éxito en el contexto de depuración.
        print("✅ ÉXITO: \(message)")
    }

    @objc private func handleClose() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate (Para manejar el teclado)
extension AddVehicleController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Mover el foco al siguiente campo
        switch textField {
        case cardIdTextField:
            brandTextField.becomeFirstResponder()
        case brandTextField:
            modelTextField.becomeFirstResponder()
        case modelTextField:
            yearTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
            handleSaveVehicle() // Intentar guardar si es el último campo
        }
        return true
    }
}
