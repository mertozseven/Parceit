//
//  TrackingDetailViewController.swift
//  Parceit
//
//  Created by Mert Ozseven on 29.12.2024.
//

import UIKit
import SnapKit
import MapKit

class TrackingDetailViewController: UIViewController {

    // MARK: - Properties
    var tracking: Tracking? {
        didSet {
            updatesTableView.reloadData()
            updateMapAnnotations()
        }
    }
    private var tableViewHeightConstraint: Constraint?

    var events: [Event] {
        return tracking?.data?.trackings?.first?.events ?? []
    }

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.layer.cornerRadius = 10
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        return mapView
    }()

    private lazy var updatesTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .dynamicColor(light: .secondarySystemBackground, dark: .systemBackground)
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.identifier)
        return tableView
    }()

    // MARK: - Inits
    init(tracking: Tracking?) {
        self.tracking = tracking
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        updatesTableView.removeObserver(self, forKeyPath: "contentSize")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Private Methods
    private func configureView() {
        title = "Tracking Detail"
        view.backgroundColor = .dynamicColor(light: .secondarySystemBackground, dark: .systemBackground)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        stackView.addArrangedSubview(mapView)
        stackView.addArrangedSubview(updatesTableView)

        configureLayout()
        configureTableView()
        updateMapAnnotations()
        addTableViewHeightObserver()
    }

    private func configureLayout() {
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.top.bottom.equalTo(view)
        }

        stackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }

        mapView.snp.makeConstraints {
            $0.height.equalTo(300)
        }

        updatesTableView.snp.makeConstraints {
            tableViewHeightConstraint = $0.height.equalTo(0).constraint
        }
    }

    private func configureTableView() {
        updatesTableView.dataSource = self
        updatesTableView.delegate = self
    }

    private func updateMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations)

        var coordinates: [CLLocationCoordinate2D] = []
        
        for event in events {
            guard let location = event.location else { continue }
            geocodeAddress(location) { [weak self] coordinate in
                guard let coordinate = coordinate else { return }
                coordinates.append(coordinate)
                let annotation = MKPointAnnotation()
                annotation.title = event.status
                annotation.subtitle = event.occurrenceDatetime?.formattedDate()
                annotation.coordinate = coordinate
                self?.mapView.addAnnotation(annotation)
                
                if coordinates.count == self?.events.count {
                    self?.setMapRegion(for: coordinates)
                }
            }
        }
    }

    /// Sets the map's region to fit all given coordinates
    private func setMapRegion(for coordinates: [CLLocationCoordinate2D]) {
        guard !coordinates.isEmpty else { return }
        
        var region: MKCoordinateRegion
        
        if coordinates.count == 1 {
            let coordinate = coordinates.first!
            region = MKCoordinateRegion(
                center: coordinate,
                latitudinalMeters: 5000,
                longitudinalMeters: 5000
            )
        } else {
            let latitudes = coordinates.map { $0.latitude }
            let longitudes = coordinates.map { $0.longitude }
            
            let minLat = latitudes.min()!
            let maxLat = latitudes.max()!
            let minLon = longitudes.min()!
            let maxLon = longitudes.max()!
            
            let center = CLLocationCoordinate2D(
                latitude: (minLat + maxLat) / 2,
                longitude: (minLon + maxLon) / 2
            )
            let span = MKCoordinateSpan(
                latitudeDelta: (maxLat - minLat) * 1.5,
                longitudeDelta: (maxLon - minLon) * 1.5
            )
            region = MKCoordinateRegion(center: center, span: span)
        }
        
        mapView.setRegion(region, animated: true)
    }

    private func geocodeAddress(_ address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                completion(location.coordinate)
            } else {
                print("Geocoding error for address '\(address)': \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }

    private func addTableViewHeightObserver() {
        updatesTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", let newValue = change?[.newKey] as? CGSize {
            tableViewHeightConstraint?.update(offset: newValue.height)
        }
    }
}

// MARK: - UITableViewDataSource
extension TrackingDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.identifier, for: indexPath) as? EventCell else {
            return UITableViewCell()
        }
        cell.configure(with: events[indexPath.row])
        print("Cell count is \(events.count)")
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TrackingDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
