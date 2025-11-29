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
        label.text = "Ingresa los detalles del nuevo vehículo."
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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
    
    private lazy var formStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [brandTextField, modelTextField, yearTextField])
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
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 44))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 0.7, alpha: 0.5)]
        )
        tf.keyboardType = placeholder.contains("Año") ? .numberPad : .default
        return tf
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AddVehicleController.darkBackground
        setupUI()
        setupKeyboardDismiss()
    }
    
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(instructionLabel)
        view.addSubview(formStackView)
        view.addSubview(saveButton)
        
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
            
            brandTextField.heightAnchor.constraint(equalToConstant: 50),
            
            saveButton.topAnchor.constraint(equalTo: formStackView.bottomAnchor, constant: 60),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            saveButton.heightAnchor.constraint(equalToConstant: 56)
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
        guard let brand = brandTextField.text, !brand.isEmpty,
              let model = modelTextField.text, !model.isEmpty,
              let yearText = yearTextField.text, let year = Int(yearText) else {
            
            print("ERROR: Todos los campos son obligatorios y el año debe ser un número válido.")
            return
        }
        
        print("Guardando nuevo vehículo:")
        print("Marca: \(brand), Modelo: \(model), Año: \(year)")
        
        let newVehicleData: [String: Any] = [
            "marca": brand,
            "modelo": model,
            "año": year,
            "estado": "iniciado",
        ]
        print("Datos a enviar (simulado): \(newVehicleData)")
        
        dismiss(animated: true, completion: nil)
    }

    @objc private func handleClose() {
        dismiss(animated: true, completion: nil)
    }
}
