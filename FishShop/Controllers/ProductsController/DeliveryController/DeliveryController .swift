import UIKit
import MapKit

struct Order {
    let title: String
    let quantity: Int
    let price: Int
    let id: Int
    let time: String
}

class DeliveryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var orderProdData: [Order] = []
    var timer: Timer?
    
    private var tableView = UITableView()
    private var mapView: MKMapView!
    private var orderInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.barBg
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Сумма заказа: \(UserSettings.orderSum ?? 0)"
        return label
    }()
    
    private let payType: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Способ оплаты: Наличные"
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray
        //button.setTitle("Отменить заказ", for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Отменить заказ", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]), for: .normal)
        return button
    }()
    
    private let orderDoneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .orange
        button.setImage(UIImage(systemName: "swift"), for: .normal)
        return button
    }()
    
    private let fullScreenView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "arrow.up.left.and.arrow.down.right")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .systemGray2
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = .black.withAlphaComponent(0.5)
        view.contentMode = .scaleAspectFit
        view.alpha = 0.5
        return view
    }()
    
    // Ограничение высоты карты
    private var mapHeightConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Delivery"
        setupMapView()
        setupOrderInfoView()
        tableApperance()
        view.addSubview(cancelButton)
        view.addSubview(orderDoneButton)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        orderDoneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        setupConstraints()
        view.backgroundColor = R.Colors.mapColor
        // Настройка маршрута на карте
        setupRoute()
        startCheckingStatus()
        
        // Добавление жеста на карту для изменения ее размера
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMapView))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func cancelButtonAction() {
        UserSettings.activeOrder = false
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func doneButtonAction() {
        
        // Создаем экземпляр текущей даты и времени
        let currentDate = Date()
        // Инициализируем DateFormatter
        let dateFormatter = DateFormatter()
        // Устанавливаем нужный формат даты и времени
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // Преобразуем текущую дату в строку согласно установленному формату
        let dateString = dateFormatter.string(from: currentDate)
        
        // Выводим текущую дату и время
        print("Текущая дата и время: \(dateString)")
        
        print("OrderDone")
        UserSettings.activeOrder = false
        if UserSettings.ordersHistory == nil {
            UserSettings.ordersHistory = []
        }
        print("OrderInfo = \(UserSettings.orderInfo)")
        
        var order: [[BasketInfo]] = UserSettings.orderInfo
        order[0][0].orderTime = dateString
        
        UserSettings.isLocChanging = false
        UserSettings.ordersHistory.append(order)
        print("UserHistory = \(UserSettings.ordersHistory)")
        navigationController?.popViewController(animated: true)
    }
    
    func setupMapView() {
        mapView = MKMapView()
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        view.addSubview(fullScreenView)
    }
    
    func setupOrderInfoView() {
        orderInfoView.backgroundColor = R.Colors.background
        //orderInfoView.backgroundColor = .clear
        
        
        let label = UILabel()
        label.text = "Информация о заказе"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        orderInfoView.addSubview(label)
        
        let orderDetailsLabel = UILabel()
        orderDetailsLabel.text = "г. Владикавказ, ул. \(UserSettings.adress[0][0].adress)"
        
        orderDetailsLabel.textColor = .systemGray2
        orderDetailsLabel.numberOfLines = 0
        orderDetailsLabel.textAlignment = .center
        orderDetailsLabel.font = .systemFont(ofSize: 12)
        orderDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        orderInfoView.addSubview(orderDetailsLabel)
        
        view.addSubview(orderInfoView)
        view.addSubview(priceLabel)
        view.addSubview(payType)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: orderInfoView.topAnchor, constant: 16),
            //label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            orderDetailsLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            //orderDetailsLabel.leadingAnchor.constraint(equalTo: orderInfoView.leadingAnchor, constant: 8),
            // orderDetailsLabel.trailingAnchor.constraint(equalTo: orderInfoView.trailingAnchor, constant: -8),
            orderDetailsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
    }
    
    func setupConstraints() {
        mapHeightConstraint = mapView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.25)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapHeightConstraint,
            
            orderInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            orderInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            orderInfoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            orderInfoView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            
            fullScreenView.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 32),
            fullScreenView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 32),
            fullScreenView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -32),
            fullScreenView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -32),
            
            tableView.topAnchor.constraint(equalTo: orderInfoView.topAnchor,constant: 80),
            tableView.leadingAnchor.constraint(equalTo: orderInfoView.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: orderInfoView.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height/4),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: view.bounds.width/2),
            cancelButton.heightAnchor.constraint(equalToConstant: 16),
            
            orderDoneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            orderDoneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            orderDoneButton.widthAnchor.constraint(equalToConstant: 24),
            orderDoneButton.heightAnchor.constraint(equalToConstant: 24),
            
            priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -56),
            priceLabel.heightAnchor.constraint(equalToConstant: 25),
            priceLabel.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
            payType.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            payType.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            payType.heightAnchor.constraint(equalToConstant: 16),
            payType.widthAnchor.constraint(equalToConstant: view.bounds.width),
        ])
        
    }
    
    func setupRoute() {
        let latitude = UserSettings.adress[0][0].latitude
        let longitude = UserSettings.adress[0][0].longitude
        
        let shopCoordinate = CLLocationCoordinate2D(latitude: 43.025773, longitude: 44.668137)
        let clientCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let shopAnnotation = MKPointAnnotation()
        shopAnnotation.coordinate = shopCoordinate
        shopAnnotation.title = "Магазин"
        
        let clientAnnotation = MKPointAnnotation()
        clientAnnotation.coordinate = clientCoordinate
        clientAnnotation.title = "Клиент"
        
        mapView.addAnnotations([shopAnnotation, clientAnnotation])
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: shopCoordinate))
        directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: clientCoordinate))
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Ошибка: \(error.localizedDescription)")
                }
                return
            }
            
            if let route = response.routes.first {
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
    }
    
    @objc func didTapMapView() {
        let isExpanded = mapHeightConstraint.constant == view.frame.height
        
        UIView.animate(withDuration: 0.3) {
            self.mapHeightConstraint.constant = isExpanded ? self.view.frame.height * 0.25 : self.view.frame.height
            self.self.fullScreenView.alpha = isExpanded ? 0.5 : 0
            self.view.layoutIfNeeded()
        }
    }
    
    func tableApperance() {
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.backgroundColor = R.Colors.barBg
        self.tableView.estimatedRowHeight = 150
        self.tableView.layer.cornerRadius = 20
        self.tableView.allowsSelection = false
        self.tableView.isEditing = false
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.register(DeliveryCell.self, forCellReuseIdentifier: DeliveryCell.id)
        
        
        for i in UserSettings.orderInfo {
            orderProdData.append(.init(title: i[0].title, quantity: i[0].quantity, price: Int(i[0].price), id: i[0].id, time: i[0].orderTime))
        }
        
        view.addSubview(tableView)
    }
}

extension DeliveryViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue // Измените на любой другой цвет
            renderer.lineWidth = 4.0
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderProdData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryCell.id, for: indexPath) as! DeliveryCell
        let basketData = self.orderProdData[indexPath.row]
        
        if basketData.quantity != 0 {
            cell.config(title: basketData.title, quantity: basketData.quantity, price: basketData.price)
        }
        
        //print("UserSettig Basket == \(UserSettings.basketInfo)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("CELL")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
        
    }
    
    
    func startCheckingStatus() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(checkDeliveryStatus), userInfo: nil, repeats: true)
    }
    
    
    //--MARK: Back: checkStatus bbb
    @objc func checkDeliveryStatus() {
        guard let url = URL(string: "http://192.168.0.111:5002/checkStatus") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let deliveryStatus = jsonResponse["delivered"] as? Bool {
                    print("Delivery Status: \(deliveryStatus)")
                    
                    if deliveryStatus {
                        self.timer?.invalidate()
                        self.timer = nil
                        print("Delivery confirmed. Stopping checks.")
                        DispatchQueue.main.async {
                            self.doneButtonAction()
                        }
                    }
                }
            } catch {
                print("Error parsing response: \(error)")
            }
        }
        
        task.resume()
    }
}
