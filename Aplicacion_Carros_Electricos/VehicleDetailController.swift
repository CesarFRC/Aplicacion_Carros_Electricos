import UIKit

class VehicleDetailController: UIViewController {

    // MARK: - Propiedades

    var vehicle: Vehicle // El vehículo que se mostrará
    
    // MARK: - Color Palette
    private let darkBackground = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
    private let neonGreen = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
    private let primaryCardColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0) // Blanco casi puro
    private let darkGrayCard = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)

    // MARK: - UI Components
    
    // Vista superior
    private let topInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Título "FULL CHARGE"
    private let appTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "FULL CHARGE"
        label.textColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 24, weight: .black)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Label de estado activo/inactivo
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Ícono de carga
    private let boltIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bolt.fill")
        imageView.tintColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Card de Carga Principal (Mejorada)
    private let chargeCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15 // Bordes más suaves
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15 // Sombra más visible
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Icono de batería (Grande y Dinámico)
    private let batteryIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "battery.100.bolt.fill") // Usar la versión .fill para mejor impacto
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // Label del Porcentaje de Carga (Nuevo, centrado sobre el icono)
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "85%"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 50, weight: .heavy) // Fuente muy grande para destacar
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Label "Carga"
    private let chargeLabel: UILabel = {
        let label = UILabel()
        label.text = "Nivel de Carga"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Indicador de Nivel de Carga (punto rojo - se mantiene para consistencia)
    private let chargeIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Colección para Humedad y Temperatura
    private var dataCollectionView: UICollectionView!
    
    // MARK: - Inicialización
    
    init(vehicle: Vehicle) {
        self.vehicle = vehicle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = darkBackground
        setupTopBar()
        setupChargeCard()
        setupDataCollectionView()
        // NOTA: updateUIWithVehicleData() se llama aquí para usar los valores hardcodeados
        // que evitan errores si el struct Vehicle no tiene las propiedades necesarias.
        updateUIWithVehicleData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topInfoView.layer.cornerRadius = 20
        topInfoView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    // MARK: - UI Setup
    
    private func setupTopBar() {
        view.addSubview(topInfoView)
        topInfoView.addSubview(boltIcon)
        topInfoView.addSubview(appTitleLabel)
        topInfoView.addSubview(statusLabel)
        
        // Botón de cerrar para volver al Feed
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        closeButton.tintColor = neonGreen
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        topInfoView.addSubview(closeButton)


        NSLayoutConstraint.activate([
            topInfoView.topAnchor.constraint(equalTo: view.topAnchor),
            topInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topInfoView.heightAnchor.constraint(equalToConstant: 160),

            // Botón de Cerrar
            closeButton.leadingAnchor.constraint(equalTo: topInfoView.leadingAnchor, constant: 20),
            closeButton.topAnchor.constraint(equalTo: topInfoView.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            // Icono
            boltIcon.topAnchor.constraint(equalTo: topInfoView.safeAreaLayoutGuide.topAnchor, constant: 10),
            boltIcon.centerXAnchor.constraint(equalTo: topInfoView.centerXAnchor),
            boltIcon.widthAnchor.constraint(equalToConstant: 40),
            boltIcon.heightAnchor.constraint(equalToConstant: 40),

            // Título App
            appTitleLabel.topAnchor.constraint(equalTo: boltIcon.bottomAnchor, constant: 4),
            appTitleLabel.centerXAnchor.constraint(equalTo: topInfoView.centerXAnchor),

            // Label de Estado (debajo del título)
            statusLabel.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor, constant: 5),
            statusLabel.centerXAnchor.constraint(equalTo: topInfoView.centerXAnchor)
        ])
    }
    
    private func setupChargeCard() {
        view.addSubview(chargeCard)
        chargeCard.addSubview(batteryIcon)
        chargeCard.addSubview(percentageLabel) // Nuevo label de porcentaje
        chargeCard.addSubview(chargeLabel)
        chargeCard.addSubview(chargeIndicator)
        
        NSLayoutConstraint.activate([
            // Card de Carga
            chargeCard.topAnchor.constraint(equalTo: topInfoView.bottomAnchor, constant: 20),
            chargeCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chargeCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chargeCard.heightAnchor.constraint(equalToConstant: 220), // Alto fijo

            // Icono de Batería (Centrado)
            batteryIcon.centerXAnchor.constraint(equalTo: chargeCard.centerXAnchor),
            batteryIcon.topAnchor.constraint(equalTo: chargeCard.topAnchor, constant: 30),
            batteryIcon.widthAnchor.constraint(equalTo: chargeCard.widthAnchor, multiplier: 0.7), // Más ancho
            batteryIcon.heightAnchor.constraint(equalToConstant: 100),
            
            // Label de Porcentaje (centrado verticalmente en el icono)
            percentageLabel.centerXAnchor.constraint(equalTo: chargeCard.centerXAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: batteryIcon.centerYAnchor, constant: -5), // Ajuste visual
            
            // Label "Nivel de Carga"
            chargeLabel.topAnchor.constraint(equalTo: batteryIcon.bottomAnchor, constant: 15),
            chargeLabel.centerXAnchor.constraint(equalTo: chargeCard.centerXAnchor),
            
            // Indicador de Nivel de Carga (punto al lado del label)
            chargeIndicator.widthAnchor.constraint(equalToConstant: 10),
            chargeIndicator.heightAnchor.constraint(equalToConstant: 10),
            chargeIndicator.leadingAnchor.constraint(equalTo: chargeLabel.trailingAnchor, constant: 5),
            chargeIndicator.centerYAnchor.constraint(equalTo: chargeLabel.centerYAnchor)
        ])
    }

    private func setupDataCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        dataCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        dataCollectionView.backgroundColor = .clear
        dataCollectionView.translatesAutoresizingMaskIntoConstraints = false
        dataCollectionView.dataSource = self
        dataCollectionView.delegate = self
        dataCollectionView.register(DataCell.self, forCellWithReuseIdentifier: DataCell.reuseIdentifier)
        
        view.addSubview(dataCollectionView)
        
        NSLayoutConstraint.activate([
            dataCollectionView.topAnchor.constraint(equalTo: chargeCard.bottomAnchor, constant: 20),
            dataCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dataCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dataCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Data Binding
    
    // NOTA: Se comenta el código que depende de la estructura Vehicle
    // Si la estructura Vehicle no está disponible, este código generará un error de compilación.
    // Solo se deja la lógica de UI hardcodeada para que la vista se muestre.
    private func updateUIWithVehicleData() {
        // --- Actualiza la barra superior de Estado (Hardcodeado) ---
        let statusText = "Estado: Activo"
        let statusColor: UIColor = neonGreen
        
        let attributedString = NSMutableAttributedString(string: statusText)
        let pointAttachment = NSTextAttachment()
        pointAttachment.image = UIImage(systemName: "circle.fill")?.withTintColor(statusColor)
        pointAttachment.bounds = CGRect(x: 5, y: -2, width: 8, height: 8)
        
        attributedString.append(NSAttributedString(attachment: pointAttachment))
        statusLabel.attributedText = attributedString
        
        // --- Actualiza el Card de Carga (Hardcodeado) ---
        let chargeLevel = 85 // Hardcodeado
        
        // 1. Icono de la batería (dinámico basado en valor hardcodeado)
        let level = (chargeLevel / 25) * 25
        let batteryIconName = "battery.\(level).bolt.fill"
        let batteryColor: UIColor = neonGreen
        
        batteryIcon.image = UIImage(systemName: batteryIconName)
        batteryIcon.tintColor = batteryColor
        
        // 2. Porcentaje de carga (Hardcodeado)
        percentageLabel.text = "\(chargeLevel)%"
        percentageLabel.textColor = batteryColor
        
        // 3. Indicador (punto)
        chargeIndicator.backgroundColor = batteryColor
        
        // Recargar la colección
        dataCollectionView.reloadData()
    }

    // MARK: - Actions
    
    @objc private func handleClose() {
        // Cierra la vista de detalle y regresa al Feed
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension VehicleDetailController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataCell.reuseIdentifier, for: indexPath) as! DataCell
        
        if indexPath.item == 0 {
            // Celda de Humedad (Gota azul)
            cell.configure(
                iconName: "drop.fill",
                title: "Humedad",
                value: "45%", // <-- HARDCODEADO
                iconColor: .systemBlue,
                valueColor: .black // Valor negro para contraste
            )
        } else {
            // Celda de Temperatura (Termómetro naranja)
            cell.configure(
                iconName: "thermometer.sun.fill",
                title: "Temperatura",
                value: "25.5°C", // <-- HARDCODEADO
                iconColor: .systemOrange,
                valueColor: .black // Valor negro para contraste
            )
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension VehicleDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Layout de dos columnas
        let totalWidth = collectionView.bounds.width
        let spacing: CGFloat = 20
        let itemWidth = (totalWidth - spacing) / 2
        return CGSize(width: itemWidth, height: itemWidth * 1.1) // Un poco más alto que ancho
    }
}

// MARK: - Custom Cell para Humedad y Temperatura (DataCell)

class DataCell: UICollectionViewCell {
    static let reuseIdentifier = "DataCell"
    
    // Icono que cambia de color según el dato
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // Título (Humedad o Temperatura)
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Valor (el dato numérico con su unidad)
    let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.15 // Sombra mejorada
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 8 // Sombra más grande
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            // Icono
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            iconImageView.widthAnchor.constraint(equalToConstant: 45), // Icono un poco más grande
            iconImageView.heightAnchor.constraint(equalToConstant: 45),
            
            // Título (Humedad/Temperatura)
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Valor (e.g., "45%" o "25.5°C")
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            valueLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    // Función para configurar la celda con los datos y el estilo
    // Se agrega valueColor para mayor control
    func configure(iconName: String, title: String, value: String, iconColor: UIColor, valueColor: UIColor) {
        iconImageView.image = UIImage(systemName: iconName)
        iconImageView.tintColor = iconColor
        titleLabel.text = title
        valueLabel.text = value
        valueLabel.textColor = valueColor
    }
}
