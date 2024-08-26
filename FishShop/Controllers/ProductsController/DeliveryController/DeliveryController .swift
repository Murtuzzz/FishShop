import UIKit
import MapKit

struct Order {
    let title: String
    let quantity: Int
    let price: Int
    let id: Int
}

class DeliveryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var orderProdData: [Order] = []
    
    private var tableView = UITableView()
    private var mapView: MKMapView!
    private var orderInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.barBg
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray
        //button.setTitle("Отменить заказ", for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Отменить заказ", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]), for: .normal)
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
        setupConstraints()
        view.backgroundColor = R.Colors.mapColor
        // Настройка маршрута на карте
        setupRoute()
        
        // Добавление жеста на карту для изменения ее размера
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMapView))
        mapView.addGestureRecognizer(tapGesture)
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
            cancelButton.heightAnchor.constraint(equalToConstant: 16)
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
            orderProdData.append(.init(title: i[0].title, quantity: i[0].quantity, price: Int(i[0].price), id: i[0].id ))
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
}
