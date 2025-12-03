import UIKit

// MARK: - Modelos de Respuesta API
struct VehicleDataResponse: Codable {
    let vehiculo: VehiculoDetalle
    let sensores: [SensorData]
}

struct VehiculoDetalle: Codable {
    let id: String
    let usuarioId: String
    let marca: String
    let modelo: String
    let año: Int
    let estado: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case usuarioId = "usuario_id"
        case marca, modelo, año, estado
    }
}

struct SensorData: Codable {
    let sensor: String
    let fechaFin: String
    let valor: Double
    let fechaValor: String
    
    enum CodingKeys: String, CodingKey {
        case sensor
        case fechaFin = "fecha_fin"
        case valor
        case fechaValor = "fecha_valor"
    }
}

// MARK: - Modelo para Datos Históricos
struct HistoricalDataResponse: Codable {
    let vehiculo: VehiculoDetalle
    let sensores: [HistoricalSensor]
}

struct HistoricalSensor: Codable {
    let id: String
    let uidTarjeta: String
    let sensor: String
    let datos: [DataPoint]
    let fechaFin: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case uidTarjeta = "uid_tarjeta"
        case sensor, datos
        case fechaFin = "fecha_fin"
    }
}

struct DataPoint: Codable {
    let valor: Double
    let dt: String
}

// MARK: - Nota: Se asume que el modelo Vehicle ya está definido en tu proyecto
// con las propiedades: id, marca, modelo, año, estado

// MARK: - MiniChartView - Vista personalizada para mini-gráficas
class MiniChartView: UIView {
    
    private var values: [Double] = []
    private var lineColor: UIColor = .white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with values: [Double], color: UIColor) {
        self.values = values
        self.lineColor = color
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard !values.isEmpty else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Encontrar valores min y max
        let minValue = values.min() ?? 0
        let maxValue = values.max() ?? 1
        let range = maxValue - minValue
        
        // Si todos los valores son iguales, añadir un pequeño rango
        let adjustedRange = range == 0 ? 1.0 : range
        
        // Dibujar grid sutil
        context.setStrokeColor(UIColor.white.withAlphaComponent(0.1).cgColor)
        context.setLineWidth(1)
        
        for i in 0...4 {
            let y = rect.height * CGFloat(i) / 4.0
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: rect.width, y: y))
        }
        context.strokePath()
        
        // Dibujar área bajo la curva (gradiente)
        let path = UIBezierPath()
        
        let stepX = rect.width / CGFloat(values.count - 1)
        
        for (index, value) in values.enumerated() {
            let normalizedValue = (value - minValue) / adjustedRange
            let x = CGFloat(index) * stepX
            let y = rect.height - (CGFloat(normalizedValue) * rect.height)
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        // Completar el path para crear el área
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.close()
        
        // Dibujar gradiente
        context.saveGState()
        path.addClip()
        
        let colors = [lineColor.withAlphaComponent(0.3).cgColor, lineColor.withAlphaComponent(0.0).cgColor]
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: [0, 1])!
        
        context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: rect.height), options: [])
        context.restoreGState()
        
        // Dibujar línea
        context.setStrokeColor(lineColor.cgColor)
        context.setLineWidth(3)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        for (index, value) in values.enumerated() {
            let normalizedValue = (value - minValue) / adjustedRange
            let x = CGFloat(index) * stepX
            let y = rect.height - (CGFloat(normalizedValue) * rect.height)
            
            if index == 0 {
                context.move(to: CGPoint(x: x, y: y))
            } else {
                context.addLine(to: CGPoint(x: x, y: y))
            }
        }
        context.strokePath()
        
        // Dibujar punto actual (último valor)
        if let lastValue = values.last {
            let normalizedValue = (lastValue - minValue) / adjustedRange
            let x = rect.width
            let y = rect.height - (CGFloat(normalizedValue) * rect.height)
            
            // Círculo exterior (glow)
            context.setFillColor(lineColor.withAlphaComponent(0.3).cgColor)
            context.fillEllipse(in: CGRect(x: x - 8, y: y - 8, width: 16, height: 16))
            
            // Círculo interior
            context.setFillColor(lineColor.cgColor)
            context.fillEllipse(in: CGRect(x: x - 4, y: y - 4, width: 8, height: 8))
        }
    }
}

// MARK: - SensorCardWithChart - Tarjeta con mini-gráfica integrada
class SensorCardWithChart: UIView {
    
    private let sensor: SensorData
    private let dataPoints: [DataPoint]
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 0.3).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chartView: MiniChartView = {
        let view = MiniChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let trendLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(sensor: SensorData, dataPoints: [DataPoint]) {
        self.sensor = sensor
        self.dataPoints = dataPoints
        super.init(frame: .zero)
        setupView()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(containerView)
        containerView.addSubview(iconBackgroundView)
        iconBackgroundView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(valueLabel)
        containerView.addSubview(chartView)
        containerView.addSubview(trendLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            iconBackgroundView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            iconBackgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            iconBackgroundView.widthAnchor.constraint(equalToConstant: 50),
            iconBackgroundView.heightAnchor.constraint(equalToConstant: 50),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconBackgroundView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            
            titleLabel.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: iconBackgroundView.trailingAnchor, constant: 12),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            valueLabel.leadingAnchor.constraint(equalTo: iconBackgroundView.trailingAnchor, constant: 12),
            
            chartView.topAnchor.constraint(equalTo: iconBackgroundView.bottomAnchor, constant: 20),
            chartView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            chartView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            chartView.heightAnchor.constraint(equalToConstant: 120),
            
            trendLabel.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 12),
            trendLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            trendLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
    }
    
    private func configure() {
        var iconName: String
        var title: String
        var iconColor: UIColor
        var formattedValue: String
        var unit: String
        
        switch sensor.sensor {
        case "HUMD":
            iconName = "drop.fill"
            title = "Humedad"
            iconColor = .systemBlue
            formattedValue = String(format: "%.0f", sensor.valor)
            unit = "%"
            
        case "TEMP":
            iconName = "thermometer.sun.fill"
            title = "Temperatura"
            iconColor = .systemOrange
            formattedValue = String(format: "%.1f", sensor.valor)
            unit = "°C"
            
        case "VOLT":
            iconName = "bolt.fill"
            title = "Bateria"
            iconColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
            formattedValue = String(format: "%.1f", sensor.valor)
            unit = "%"
            
        case "DIST":
            iconName = "ruler.fill"
            title = "Distancia"
            iconColor = .systemPurple
            formattedValue = String(format: "%.0f", sensor.valor)
            unit = " cm"
            
        default:
            iconName = "sensor.fill"
            title = sensor.sensor
            iconColor = .gray
            formattedValue = String(format: "%.1f", sensor.valor)
            unit = ""
        }
        
        iconImageView.image = UIImage(systemName: iconName)
        iconImageView.tintColor = iconColor
        iconBackgroundView.backgroundColor = iconColor.withAlphaComponent(0.2)
        
        titleLabel.text = title
        valueLabel.text = formattedValue + unit
        
        // Configurar gráfica
        let values = dataPoints.map { $0.valor }
        chartView.configure(with: values, color: iconColor)
        
        // Calcular tendencia
        if values.count >= 2 {
            let recent = values.suffix(5)
            let avg = recent.reduce(0, +) / Double(recent.count)
            let diff = sensor.valor - avg
            
            if abs(diff) < 0.1 {
                trendLabel.text = "↔ Estable"
            } else if diff > 0 {
                trendLabel.text = "↗ Subiendo"
            } else {
                trendLabel.text = "↘ Bajando"
            }
        } else {
            trendLabel.text = "— Sin tendencia"
        }
    }
}

// MARK: - VehicleDetailController
class VehicleDetailController: UIViewController {

    var vehicle: Vehicle
    
    private let darkBackground = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
    private let neonGreen = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
    private let cardBackground = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)

    // Timer para actualización automática
    private var updateTimer: Timer?
    
    // Datos de sensores
    private var sensorDataList: [SensorData] = []
    private var historicalData: [String: [DataPoint]] = [:] // sensor name -> data points
    
    // Vista de scroll principal
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    private let vehicleInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
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
    
    // Stacks para organizar las tarjetas
    private let sensorsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Sección de historial
    private let historyHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "📊 Historial de Sensores"
        label.textColor = UIColor(red: 57/255, green: 255/255, blue: 20/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let historyStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
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
        setupScrollView()
        setupTopBar()
        setupSensorsStack()
        
        // Mostrar info del vehículo
        vehicleInfoLabel.text = "\(vehicle.marca) \(vehicle.modelo)"
        
        // Iniciar carga de datos
        fetchVehicleData()
        fetchHistoricalData()
        
        // Configurar timer para actualización cada 10 segundos
        startAutoUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAutoUpdate()
    }
    
    // MARK: - Setup UI
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupTopBar() {
        contentView.addSubview(topInfoView)
        topInfoView.addSubview(boltIcon)
        topInfoView.addSubview(appTitleLabel)
        topInfoView.addSubview(vehicleInfoLabel)
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        closeButton.tintColor = neonGreen
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        topInfoView.addSubview(closeButton)

        NSLayoutConstraint.activate([
            topInfoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topInfoView.heightAnchor.constraint(equalToConstant: 160),

            closeButton.leadingAnchor.constraint(equalTo: topInfoView.leadingAnchor, constant: 20),
            closeButton.topAnchor.constraint(equalTo: topInfoView.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            boltIcon.topAnchor.constraint(equalTo: topInfoView.safeAreaLayoutGuide.topAnchor, constant: 10),
            boltIcon.centerXAnchor.constraint(equalTo: topInfoView.centerXAnchor),
            boltIcon.widthAnchor.constraint(equalToConstant: 40),
            boltIcon.heightAnchor.constraint(equalToConstant: 40),

            appTitleLabel.topAnchor.constraint(equalTo: boltIcon.bottomAnchor, constant: 4),
            appTitleLabel.centerXAnchor.constraint(equalTo: topInfoView.centerXAnchor),

            vehicleInfoLabel.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor, constant: 5),
            vehicleInfoLabel.centerXAnchor.constraint(equalTo: topInfoView.centerXAnchor)
        ])
    }
    
    private func setupSensorsStack() {
        contentView.addSubview(sensorsStackView)
        contentView.addSubview(historyHeaderLabel)
        contentView.addSubview(historyStackView)
        
        NSLayoutConstraint.activate([
            sensorsStackView.topAnchor.constraint(equalTo: topInfoView.bottomAnchor, constant: 20),
            sensorsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sensorsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            historyHeaderLabel.topAnchor.constraint(equalTo: sensorsStackView.bottomAnchor, constant: 30),
            historyHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            historyHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            historyStackView.topAnchor.constraint(equalTo: historyHeaderLabel.bottomAnchor, constant: 15),
            historyStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            historyStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            historyStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Timer de Actualización
    private func startAutoUpdate() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.fetchHistoricalData()
            self?.fetchVehicleData()
        }
    }
    
    private func stopAutoUpdate() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    // MARK: - Fetch Data from API
    private func fetchVehicleData() {
        let urlString = "http://34.224.27.117/usuario/datos-vehiculo/\(vehicle.id)"
        
        guard let url = URL(string: urlString) else {
            print("❌ URL inválida: \(urlString)")
            return
        }
        
        print("🌐 Obteniendo datos del vehículo: \(urlString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Error en la petición: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ No se recibieron datos")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(VehicleDataResponse.self, from: data)
                
                print("✅ Datos decodificados correctamente - Sensores: \(response.sensores.count)")
                
                DispatchQueue.main.async {
                    self.sensorDataList = response.sensores
                    self.updateSensorCards()
                }
                
            } catch {
                print("❌ Error al decodificar JSON: \(error)")
            }
        }.resume()
    }
    
    private func fetchHistoricalData() {
        let urlString = "http://34.224.27.117/usuario/datos-vehiculo-historial/\(vehicle.id)"
        
        guard let url = URL(string: urlString) else {
            print("❌ URL inválida: \(urlString)")
            return
        }
        
        print("🌐 Obteniendo datos históricos: \(urlString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Error en la petición histórica: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ No se recibieron datos históricos")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(HistoricalDataResponse.self, from: data)
                
                print("✅ Datos históricos decodificados - Sensores: \(response.sensores.count)")
                
                var histData: [String: [DataPoint]] = [:]
                for sensor in response.sensores {
                    // Tomar los últimos 20 puntos para la gráfica
                    let lastPoints = Array(sensor.datos.suffix(20))
                    histData[sensor.sensor] = lastPoints
                }
                
                DispatchQueue.main.async {
                    self.historicalData = histData
                    self.updateSensorCards()
                    self.updateHistorySection(sensors: response.sensores)
                }
                
            } catch {
                print("❌ Error al decodificar datos históricos: \(error)")
            }
        }.resume()
    }
    
    private func updateSensorCards() {
        // Limpiar tarjetas existentes
        sensorsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Crear una tarjeta para cada sensor
        for sensor in sensorDataList {
            let card = createSensorCard(for: sensor)
            sensorsStackView.addArrangedSubview(card)
        }
    }
    
    private func createSensorCard(for sensor: SensorData) -> UIView {
        let cardView = SensorCardWithChart(sensor: sensor, dataPoints: historicalData[sensor.sensor] ?? [])
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.heightAnchor.constraint(equalToConstant: 280)
        ])
        
        return cardView
    }

    @objc private func handleClose() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Update History Section
    private func updateHistorySection(sensors: [HistoricalSensor]) {
        // Limpiar historial existente
        historyStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Crear una sección expandible para cada sensor
        for sensor in sensors {
            let historyCard = createHistoryCard(for: sensor)
            historyStackView.addArrangedSubview(historyCard)
        }
    }
    
    private func createHistoryCard(for sensor: HistoricalSensor) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Header del sensor
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let sensorNameLabel = UILabel()
        sensorNameLabel.textColor = .white
        sensorNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        sensorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let lastValueLabel = UILabel()
        lastValueLabel.textColor = neonGreen
        lastValueLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        lastValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let countLabel = UILabel()
        countLabel.textColor = .lightGray
        countLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        countLabel.text = "\(sensor.datos.count) registros"
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configurar según tipo de sensor
        var iconName: String
        var title: String
        var iconColor: UIColor
        var unit: String
        
        switch sensor.sensor {
        case "HUMD":
            iconName = "drop.fill"
            title = "Humedad"
            iconColor = .systemBlue
            unit = "%"
        case "TEMP":
            iconName = "thermometer.sun.fill"
            title = "Temperatura"
            iconColor = .systemOrange
            unit = "°C"
        case "VOLT":
            iconName = "bolt.fill"
            title = "Bateria"
            iconColor = neonGreen
            unit = "%"
        case "DIST":
            iconName = "ruler.fill"
            title = "Distancia"
            iconColor = .systemPurple
            unit = " cm"
        default:
            iconName = "sensor.fill"
            title = sensor.sensor
            iconColor = .gray
            unit = ""
        }
        
        iconImageView.image = UIImage(systemName: iconName)
        iconImageView.tintColor = iconColor
        sensorNameLabel.text = title
        
        // Último valor
        if let lastData = sensor.datos.last {
            lastValueLabel.text = "Último: \(String(format: "%.1f", lastData.valor))\(unit)"
        } else {
            lastValueLabel.text = "Sin datos"
        }
        
        // Tabla de datos
        let tableView = createDataTable(for: sensor.datos, unit: unit, color: iconColor)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Agregar subvistas
        containerView.addSubview(headerView)
        headerView.addSubview(iconImageView)
        headerView.addSubview(sensorNameLabel)
        headerView.addSubview(lastValueLabel)
        headerView.addSubview(countLabel)
        containerView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            iconImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            sensorNameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            sensorNameLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            
            lastValueLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            lastValueLabel.topAnchor.constraint(equalTo: sensorNameLabel.bottomAnchor, constant: 4),
            
            countLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            countLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15)
        ])
        
        return containerView
    }
    
    private func createDataTable(for dataPoints: [DataPoint], unit: String, color: UIColor) -> UIView {
        let tableContainer = UIView()
        tableContainer.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1.0)
        tableContainer.layer.cornerRadius = 12
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let recentData = Array(dataPoints.suffix(9).reversed())
        for (index, dataPoint) in recentData.enumerated() {
                let rowView = createDataRow(dataPoint: dataPoint, unit: unit, color: color, isEven: index % 2 == 0)
                stackView.addArrangedSubview(rowView)
        }
        
        tableContainer.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: tableContainer.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: tableContainer.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: tableContainer.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: tableContainer.bottomAnchor)
        ])
        
        return tableContainer
    }
    
    private func createDataRow(dataPoint: DataPoint, unit: String, color: UIColor, isEven: Bool) -> UIView {
        let rowView = UIView()
        rowView.backgroundColor = isEven ? UIColor(white: 0.15, alpha: 1.0) : UIColor(white: 0.1, alpha: 1.0)
        rowView.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabel = UILabel()
        dateLabel.textColor = .lightGray
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.textColor = color
        valueLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Formatear fecha
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: dataPoint.dt) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "dd/MM/yy HH:mm"
            dateLabel.text = displayFormatter.string(from: date)
        } else {
            dateLabel.text = dataPoint.dt
        }
        
        valueLabel.text = String(format: "%.1f", dataPoint.valor) + unit
        
        rowView.addSubview(dateLabel)
        rowView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            rowView.heightAnchor.constraint(equalToConstant: 36),
            
            dateLabel.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: 12),
            dateLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: rowView.trailingAnchor, constant: -12),
            valueLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor)
        ])
        
        return rowView
    }
}
