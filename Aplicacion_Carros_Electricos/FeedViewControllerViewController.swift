import UIKit


class FeedViewController: UIViewController {

    // MARK: - Color Palette
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
    
    private let userCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userAvatarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 0.2)
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userAvatarLabel: UILabel = {
        let label = UILabel()
        label.text = "JP"
        label.textColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Juan Pérez Ramírez"
        label.textColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Conductor Verificado"
        label.textColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        label.text = "1 vehículo"
        label.textColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var collectionView: UICollectionView!
    
    // --- Datos de ejemplo de Vehículos ---
    private var vehicles: [Vehicle] = [
        // NOTA: Se agregaron las propiedades que necesita VehicleDetailController
        Vehicle(name: "Honda Civic", imageName: "honda_civic_red", battery: 85, status: "Cargando", chargeLevel: 85, humidity: 45, temperature: 25.5),
    ]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = darkBackground
        setupHeaderView()
        setupUserCard()
        setupSectionHeader()
        setupCollectionView()
        registerCells()
        updateVehicleCount()
    }

    // MARK: - UI Setup

    private func setupHeaderView() {
        view.addSubview(headerView)
        headerView.addSubview(boltIcon)
        headerView.addSubview(appTitleLabel)

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
        ])
    }
    
    private func setupUserCard() {
        view.addSubview(userCard)
        userCard.addSubview(userAvatarView)
        userAvatarView.addSubview(userAvatarLabel)
        userCard.addSubview(userNameLabel)
        userCard.addSubview(userSubtitleLabel)
        
        NSLayoutConstraint.activate([
            userCard.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            userCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            userCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            userCard.heightAnchor.constraint(equalToConstant: 80),
            
            userAvatarView.leadingAnchor.constraint(equalTo: userCard.leadingAnchor, constant: 16),
            userAvatarView.centerYAnchor.constraint(equalTo: userCard.centerYAnchor),
            userAvatarView.widthAnchor.constraint(equalToConstant: 50),
            userAvatarView.heightAnchor.constraint(equalToConstant: 50),
            
            userAvatarLabel.centerXAnchor.constraint(equalTo: userAvatarView.centerXAnchor),
            userAvatarLabel.centerYAnchor.constraint(equalTo: userAvatarView.centerYAnchor),
            
            userNameLabel.leadingAnchor.constraint(equalTo: userAvatarView.trailingAnchor, constant: 16),
            userNameLabel.topAnchor.constraint(equalTo: userAvatarView.topAnchor, constant: 6),
            userNameLabel.trailingAnchor.constraint(equalTo: userCard.trailingAnchor, constant: -16),
            
            userSubtitleLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            userSubtitleLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4),
            userSubtitleLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
        ])
    }
    
    private func setupSectionHeader() {
        view.addSubview(sectionTitleLabel)
        view.addSubview(vehicleCountLabel)
        
        NSLayoutConstraint.activate([
            sectionTitleLabel.topAnchor.constraint(equalTo: userCard.bottomAnchor, constant: 32),
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
        vehicleCountLabel.text = count == 1 ? "1 vehículo" : "\(count) vehículos"
    }

    private func presentAddVehicleScreen() {
        print("Mostrar pantalla para agregar nuevo vehículo")
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
    
    // FUNCIÓN CLAVE: didSelectItemAt es el manejador de clics en las celdas
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1. Verificar si la celda seleccionada es un vehículo (índice menor al total de vehículos)
        if indexPath.item < vehicles.count {
            
            // 2. Obtener la información del vehículo específico
            let selectedVehicle = vehicles[indexPath.item]
            print("Navegando al detalle del vehículo: \(selectedVehicle.name)")
            
            // 3. Instanciar el controlador de destino (VehicleDetailController)
            // Se le pasa el objeto 'vehicle' con todos sus datos.
            let detailVC = VehicleDetailController(vehicle: selectedVehicle)
            
            // 4. Presentar la nueva pantalla con una animación
            detailVC.modalPresentationStyle = .fullScreen
            present(detailVC, animated: true)
            
        } else {
            // Si el índice es igual al total de vehículos, es el botón de "Agregar"
            presentAddVehicleScreen()
        }
    }
}

// MARK: - Modelo de Datos
// El struct Vehicle contiene todos los datos que se pasan a la pantalla de detalle.

struct Vehicle {
    let name: String
    let imageName: String
    let battery: Int
    let status: String
    // Propiedades necesarias para VehicleDetailController
    let chargeLevel: Int
    let humidity: Int
    let temperature: Double
}

// MARK: - Custom Cells
// (Las clases VehicleCell y AddVehicleCell están definidas para el diseño de la colección)

class VehicleCell: UICollectionViewCell {
    static let reuseIdentifier = "VehicleCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let batteryContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let batteryIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bolt.fill")
        iv.tintColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let batteryLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
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
        containerView.addSubview(imageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(batteryContainerView)
        batteryContainerView.addSubview(batteryIcon)
        batteryContainerView.addSubview(batteryLabel)
        containerView.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85),
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.4),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            batteryContainerView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            batteryContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            batteryContainerView.heightAnchor.constraint(equalToConstant: 28),
            batteryContainerView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
            
            batteryIcon.leadingAnchor.constraint(equalTo: batteryContainerView.leadingAnchor, constant: 8),
            batteryIcon.centerYAnchor.constraint(equalTo: batteryContainerView.centerYAnchor),
            batteryIcon.widthAnchor.constraint(equalToConstant: 14),
            batteryIcon.heightAnchor.constraint(equalToConstant: 14),
            
            batteryLabel.leadingAnchor.constraint(equalTo: batteryIcon.trailingAnchor, constant: 6),
            batteryLabel.centerYAnchor.constraint(equalTo: batteryContainerView.centerYAnchor),
            batteryLabel.trailingAnchor.constraint(equalTo: batteryContainerView.trailingAnchor, constant: -8),
            
            statusLabel.topAnchor.constraint(equalTo: batteryContainerView.bottomAnchor, constant: 8),
            statusLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            statusLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with vehicle: Vehicle) {
        imageView.image = UIImage(named: vehicle.imageName)
        nameLabel.text = vehicle.name
        batteryLabel.text = "\(vehicle.battery)%"
        statusLabel.text = vehicle.status
    }
}

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
