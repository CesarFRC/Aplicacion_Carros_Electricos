import UIKit

// MARK: - Modelos de Datos CORREGIDOS
// Se hacen opcionales los campos que no vienen en la respuesta de la API de vehículos,
// como 'usuario_id' y 'año', para evitar el error keyNotFound.
struct VehiculoAPI: Codable {
    let id: String
    let marca: String
    let modelo: String
    let estado: String
    
    // Estos campos ya no vienen en la API de vehiculos, se declaran como opcionales
    let usuarioId: String?
    let año: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case marca, modelo, estado
        case usuarioId = "usuario_id"
        case año
    }
}

// Modelo interno para la UI, con valores por defecto
struct Vehicle {
    let id: String
    let marca: String
    let modelo: String
    let año: Int // Mantener como Int para el modelo interno, pero será 0
    let estado: String
    let cargaBateria: Int // Este campo ya no se usará en la UI, pero se mantiene en el modelo
}

class FeedViewController: UIViewController {

    
    private let darkBackground = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
    private let neonGreen = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
    private let lightGray = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    private let cardBackground = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
    private let softGray = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let boltIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bolt.fill")
        imageView.tintColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let appTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "FULL CHARGE"
        label.textColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 22, weight: .black)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // ⭐ ELIMINAMOS logoutButton y su lógica
    // private lazy var logoutButton: UIButton = { ... }()
    // @objc private func logoutTapped() { ... }
    
    private let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mis Vehículos"
        label.textColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let vehicleCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Cargando..."
        label.textColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var collectionView: UICollectionView!
    private var vehicles: [Vehicle] = []
    private var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = darkBackground
        setupHeaderView()
        setupSectionHeader()
        setupCollectionView()
        registerCells()
        
        guard UserSession.shared.isLoggedIn else {
            print("❌ No hay usuario logueado, redirigiendo al login...")
            showEmptyState()
            return
        }
        
        fetchVehicleData()
    }

    // MARK: - Fetch Data from API
    private func fetchVehicleData() {
        guard !isLoading else { return }
        
        guard let usuarioId = UserSession.shared.userId else {
            print("❌ No hay ID de usuario guardado")
            showEmptyState()
            return
        }
        
        isLoading = true
        updateVehicleCount()
        
        let urlString = "http://34.224.27.117/usuario/vehiculos/\(usuarioId)"
        guard let url = URL(string: urlString) else {
            print("❌ URL inválida: \(urlString)")
            DispatchQueue.main.async {
                self.isLoading = false
                self.updateVehicleCount()
            }
            return
        }
        
        print("🌐 Haciendo petición a: \(urlString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Error en la petición: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.showEmptyState()
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Código de respuesta: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode != 200 {
                    print("❌ Error del servidor: código \(httpResponse.statusCode)")
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.showEmptyState()
                    }
                    return
                }
            }
            
            guard let data = data else {
                print("❌ No se recibieron datos")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.showEmptyState()
                }
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 Datos recibidos: \(jsonString)")
            }
            
            do {
                let decoder = JSONDecoder()
                // Decodificar como ARRAY de VehiculoAPI
                let vehiculosAPI = try decoder.decode([VehiculoAPI].self, from: data)
                
                print("✅ \(vehiculosAPI.count) Vehículo(s) decodificado(s) de la API.")
                
                // Mapear los modelos de API a tus modelos de UI (Vehicle)
                let vehicles = vehiculosAPI.map { apiVehicle in
                    // Ya no usamos apiVehicle.año, usamos 0 como valor predeterminado
                    return Vehicle(
                        id: apiVehicle.id,
                        marca: apiVehicle.marca,
                        modelo: apiVehicle.modelo,
                        año: 0, // Fijo en 0
                        estado: apiVehicle.estado,
                        cargaBateria: 0 // Valor temporal
                    )
                }
                
                // ⭐ ACTUALIZACIÓN DE UI EN HILO PRINCIPAL
                DispatchQueue.main.async {
                    self.vehicles = vehicles
                    self.isLoading = false
                    self.updateVehicleCount()
                    self.collectionView.reloadData()
                    print("✅ UI actualizada con \(self.vehicles.count) vehículo(s)")
                }
                
            } catch {
                print("❌ Error al decodificar JSON: \(error)")
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        print("    Key '\(key.stringValue)' no encontrada: \(context.debugDescription)")
                    case .typeMismatch(let type, let context):
                        print("    Type mismatch para tipo \(type): \(context.debugDescription)")
                    case .valueNotFound(let type, let context):
                        print("    Valor no encontrado para tipo \(type): \(context.debugDescription)")
                    case .dataCorrupted(let context):
                        print("    Datos corruptos: \(context.debugDescription)")
                    @unknown default:
                        print("    Error de decodificación desconocido")
                    }
                }
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.showEmptyState()
                }
            }
        }.resume()
    }
    
    private func showEmptyState() {
        vehicles = []
        updateVehicleCount()
        collectionView.reloadData()
    }

    private func setupHeaderView() {
        view.addSubview(headerView)
        headerView.addSubview(boltIcon)
        headerView.addSubview(appTitleLabel)
        // ⭐ logoutButton ELIMINADO de aquí

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 120),

            boltIcon.topAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.topAnchor, constant: 16),
            boltIcon.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            boltIcon.widthAnchor.constraint(equalToConstant: 32),
            boltIcon.heightAnchor.constraint(equalToConstant: 32),

            appTitleLabel.topAnchor.constraint(equalTo: boltIcon.bottomAnchor, constant: 6),
            appTitleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            // ⭐ RESTRICCIONES DE LOGOUT ELIMINADAS (estaban relacionadas a appTitleLabel)
        ])
    }
    
    private func setupSectionHeader() {
        view.addSubview(sectionTitleLabel)
        view.addSubview(vehicleCountLabel)
        
        NSLayoutConstraint.activate([
            sectionTitleLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            vehicleCountLabel.centerYAnchor.constraint(equalTo: sectionTitleLabel.centerYAnchor),
            vehicleCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 20, right: 0)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func registerCells() {
        collectionView.register(VehicleCell.self, forCellWithReuseIdentifier: VehicleCell.reuseIdentifier)
        collectionView.register(AddVehicleCell.self, forCellWithReuseIdentifier: AddVehicleCell.reuseIdentifier)
    }
    
    private func updateVehicleCount() {
        let count = vehicles.count
        if isLoading {
            vehicleCountLabel.text = "Cargando..."
        } else if count == 0 {
            vehicleCountLabel.text = "Sin vehículos"
        } else {
            vehicleCountLabel.text = count == 1 ? "1 vehículo" : "\(count) vehículos"
        }
    }

    private func presentAddVehicleScreen() {
        print("🚗 Navegando a la pantalla de Agregar Vehículo.")
        let addVC = AddVehicleController()
        addVC.modalPresentationStyle = .fullScreen
        present(addVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension FeedViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vehicles.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < vehicles.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VehicleCell.reuseIdentifier, for: indexPath) as! VehicleCell
            let vehicle = vehicles[indexPath.item]
            cell.configure(with: vehicle)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddVehicleCell.reuseIdentifier, for: indexPath) as! AddVehicleCell
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let totalWidth = collectionView.bounds.width - padding
        let itemWidth = totalWidth / 2
        return CGSize(width: itemWidth, height: itemWidth * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < vehicles.count {
            let selectedVehicle = vehicles[indexPath.item]
            print("🚗 Navegando al detalle del vehículo: \(selectedVehicle.marca) \(selectedVehicle.modelo)")
            
            // ⭐ AQUI NAVEGARÍAS AL DETALLE DEL VEHÍCULO
            // let detailVC = VehicleDetailController(vehicle: selectedVehicle)
            // detailVC.modalPresentationStyle = .fullScreen
            // present(detailVC, animated: true)
            
        } else {
            presentAddVehicleScreen()
        }
    }
}

// MARK: - VehicleCell
class VehicleCell: UICollectionViewCell {
    static let reuseIdentifier = "VehicleCell"
    
    private let containerView: UIView = {
        let view = UIView()
        // ⭐ Fondo oscuro para la celda
        view.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
        view.layer.cornerRadius = 16
        // Sombra suave en color neón para el efecto "caja encendida"
        view.layer.shadowColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 0.2).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let carIconView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 0.1)
        view.layer.cornerRadius = 40
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let carIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "car.fill")
        iv.tintColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let marcaLabel: UILabel = {
        let label = UILabel()
        // ⭐ Texto blanco
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let modeloLabel: UILabel = {
        let label = UILabel()
        // ⭐ Texto gris claro
        label.textColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // ⭐ SE OCULTA añoLabel (sin cambios, ya estaba oculto)
    private let añoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    // ⭐ ELIMINAMOS batteryContainerView
    // private let batteryContainerView: UIView = { ... }()
    // private let batteryIcon: UIImageView = { ... }()
    // private let batteryLabel: UILabel = { ... }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        // ⭐ Texto gris claro
        label.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold) // Hacemos la fuente un poco más grande
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
        contentView.addSubview(containerView)
        containerView.addSubview(carIconView)
        carIconView.addSubview(carIcon)
        containerView.addSubview(marcaLabel)
        containerView.addSubview(modeloLabel)
        containerView.addSubview(añoLabel)
        // ⭐ ELIMINAMOS elementos de batería
        // containerView.addSubview(batteryContainerView)
        // batteryContainerView.addSubview(batteryIcon)
        // batteryContainerView.addSubview(batteryLabel)
        containerView.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            carIconView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            carIconView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            carIconView.widthAnchor.constraint(equalToConstant: 80),
            carIconView.heightAnchor.constraint(equalToConstant: 80),
            
            carIcon.centerXAnchor.constraint(equalTo: carIconView.centerXAnchor),
            carIcon.centerYAnchor.constraint(equalTo: carIconView.centerYAnchor),
            carIcon.widthAnchor.constraint(equalToConstant: 40),
            carIcon.heightAnchor.constraint(equalToConstant: 40),
            
            marcaLabel.topAnchor.constraint(equalTo: carIconView.bottomAnchor, constant: 12),
            marcaLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            marcaLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            modeloLabel.topAnchor.constraint(equalTo: marcaLabel.bottomAnchor, constant: 4),
            modeloLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            modeloLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            // ⭐️ RESTRICCIÓN CLAVE: Status Label va después de Modelo Label
            statusLabel.topAnchor.constraint(equalTo: modeloLabel.bottomAnchor, constant: 20), // Espacio extra
            statusLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            statusLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16)
            
            // ⭐ RESTRICCIONES DE BATERÍA ELIMINADAS
        ])
    }
    
    func configure(with vehicle: Vehicle) {
        marcaLabel.text = vehicle.marca
        modeloLabel.text = vehicle.modelo
        
        añoLabel.isHidden = true
        
        // ⭐ ELIMINAMOS REFERENCIA A batteryLabel
        // batteryLabel.text = "\(vehicle.cargaBateria)%"
        
        // Traducir estado
        let estadoTraducido: String
        switch vehicle.estado.lowercased() {
        case "iniciado":
            estadoTraducido = "En Uso"
        case "cargando":
            estadoTraducido = "Cargando"
        case "completo":
            estadoTraducido = "Carga Completa"
        default:
            estadoTraducido = vehicle.estado.capitalized
        }
        statusLabel.text = "Estado: \(estadoTraducido)" // Indicamos que es el estado
        
        // Cambiar color del ícono según el estado
        let iconColor: UIColor
        switch vehicle.estado.lowercased() {
        case "iniciado":
            iconColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0) // Verde
        case "cargando":
            iconColor = UIColor(red: 255/255, green: 193/255, blue: 7/255, alpha: 1.0) // Amarillo
        case "completo":
            iconColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0) // Verde
        default:
            iconColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1.0) // Gris
        }
        
        carIcon.tintColor = iconColor
        carIconView.backgroundColor = iconColor.withAlphaComponent(0.1)
    }
}

// MARK: - AddVehicleCell
class AddVehicleCell: UICollectionViewCell {
    static let reuseIdentifier = "AddVehicleCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 0.3).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let plusIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "plus.circle.fill")
        iv.tintColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let addLabel: UILabel = {
        let label = UILabel()
        label.text = "Agregar\nVehículo"
        label.textColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 2
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
        contentView.addSubview(containerView)
        containerView.addSubview(plusIcon)
        containerView.addSubview(addLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            plusIcon.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            plusIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -20),
            plusIcon.widthAnchor.constraint(equalToConstant: 50),
            plusIcon.heightAnchor.constraint(equalToConstant: 50),
            
            addLabel.topAnchor.constraint(equalTo: plusIcon.bottomAnchor, constant: 12),
            addLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
}
