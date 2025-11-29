import UIKit

class VehicleDetailController: UIViewController {


    var vehicle: Vehicle
    
    private let darkBackground = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
    private let neonGreen = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
    private let primaryCardColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0) 
    private let darkGrayCard = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)

    
    private let topInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let appTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "FULL CHARGE"
        label.textColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 24, weight: .black)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let boltIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bolt.fill")
        imageView.tintColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let chargeCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let batteryIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "battery.100.bolt.fill")
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "85%"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 50, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chargeLabel: UILabel = {
        let label = UILabel()
        label.text = "Nivel de Carga"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let chargeIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var dataCollectionView: UICollectionView!
    
    
    init(vehicle: Vehicle) {
        self.vehicle = vehicle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = darkBackground
        setupTopBar()
        setupChargeCard()
        setupDataCollectionView()
        updateUIWithVehicleData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topInfoView.layer.cornerRadius = 20
        topInfoView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    
    private func setupTopBar() {
        view.addSubview(topInfoView)
        topInfoView.addSubview(boltIcon)
        topInfoView.addSubview(appTitleLabel)
        topInfoView.addSubview(statusLabel)
        
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

            closeButton.leadingAnchor.constraint(equalTo: topInfoView.leadingAnchor, constant: 20),
            closeButton.topAnchor.constraint(equalTo: topInfoView.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            boltIcon.topAnchor.constraint(equalTo: topInfoView.safeAreaLayoutGuide.topAnchor, constant: 10),
            boltIcon.centerXAnchor.constraint(equalTo: topInfoView.centerXAnchor),
            boltIcon.widthAnchor.constraint(equalToConstant: 40),
            boltIcon.heightAnchor.constraint(equalToConstant: 40),

            appTitleLabel.topAnchor.constraint(equalTo: boltIcon.bottomAnchor, constant: 4),
            appTitleLabel.centerXAnchor.constraint(equalTo: topInfoView.centerXAnchor),

            statusLabel.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor, constant: 5),
            statusLabel.centerXAnchor.constraint(equalTo: topInfoView.centerXAnchor)
        ])
    }
    
    private func setupChargeCard() {
        view.addSubview(chargeCard)
        chargeCard.addSubview(batteryIcon)
        chargeCard.addSubview(percentageLabel)
        chargeCard.addSubview(chargeLabel)
        chargeCard.addSubview(chargeIndicator)
        
        NSLayoutConstraint.activate([
            chargeCard.topAnchor.constraint(equalTo: topInfoView.bottomAnchor, constant: 20),
            chargeCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chargeCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chargeCard.heightAnchor.constraint(equalToConstant: 220),

            batteryIcon.centerXAnchor.constraint(equalTo: chargeCard.centerXAnchor),
            batteryIcon.topAnchor.constraint(equalTo: chargeCard.topAnchor, constant: 30),
            batteryIcon.widthAnchor.constraint(equalTo: chargeCard.widthAnchor, multiplier: 0.7),
            batteryIcon.heightAnchor.constraint(equalToConstant: 100),
            
            percentageLabel.centerXAnchor.constraint(equalTo: chargeCard.centerXAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: batteryIcon.centerYAnchor, constant: -5),
            
            chargeLabel.topAnchor.constraint(equalTo: batteryIcon.bottomAnchor, constant: 15),
            chargeLabel.centerXAnchor.constraint(equalTo: chargeCard.centerXAnchor),
            
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
    
    
    private func updateUIWithVehicleData() {
        let statusText = "Estado: Activo"
        let statusColor: UIColor = neonGreen
        
        let attributedString = NSMutableAttributedString(string: statusText)
        let pointAttachment = NSTextAttachment()
        pointAttachment.image = UIImage(systemName: "circle.fill")?.withTintColor(statusColor)
        pointAttachment.bounds = CGRect(x: 5, y: -2, width: 8, height: 8)
        
        attributedString.append(NSAttributedString(attachment: pointAttachment))
        statusLabel.attributedText = attributedString
        
        let chargeLevel = 85
        
        let level = (chargeLevel / 25) * 25
        let batteryIconName = "battery.\(level).bolt.fill"
        let batteryColor: UIColor = neonGreen
        
        batteryIcon.image = UIImage(systemName: batteryIconName)
        batteryIcon.tintColor = batteryColor
        
        percentageLabel.text = "\(chargeLevel)%"
        percentageLabel.textColor = batteryColor
        
        chargeIndicator.backgroundColor = batteryColor
        
        dataCollectionView.reloadData()
    }

    @objc private func handleClose() {
        dismiss(animated: true, completion: nil)
    }
}

extension VehicleDetailController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataCell.reuseIdentifier, for: indexPath) as! DataCell
        
        if indexPath.item == 0 {
            cell.configure(
                iconName: "drop.fill",
                title: "Humedad",
                value: "45%",
                iconColor: .systemBlue,
                valueColor: .black
            )
        } else {
            cell.configure(
                iconName: "thermometer.sun.fill",
                title: "Temperatura",
                value: "25.5°C",
                iconColor: .systemOrange,
                valueColor: .black
            )
        }
        return cell
    }
}


extension VehicleDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.width
        let spacing: CGFloat = 20
        let itemWidth = (totalWidth - spacing) / 2
        return CGSize(width: itemWidth, height: itemWidth * 1.1)
    }
}


class DataCell: UICollectionViewCell {
    static let reuseIdentifier = "DataCell"
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 8
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            iconImageView.widthAnchor.constraint(equalToConstant: 45),
            iconImageView.heightAnchor.constraint(equalToConstant: 45),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            valueLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    

    func configure(iconName: String, title: String, value: String, iconColor: UIColor, valueColor: UIColor) {
        iconImageView.image = UIImage(systemName: iconName)
        iconImageView.tintColor = iconColor
        titleLabel.text = title
        valueLabel.text = value
        valueLabel.textColor = valueColor
    }
}
