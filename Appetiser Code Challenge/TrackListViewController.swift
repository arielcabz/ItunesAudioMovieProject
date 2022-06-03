//
//  TrackListViewController.swift
//  Appetiser Code Challenge
//
//  Created by Ariel Dominic Cabanag on 2/5/22.
//

import Foundation
import RxCocoa
import RxSwift
class TrackListViewController: UIViewController {
    
    //MARK: [START] PRIVATE variables
    private let viewModel = TrackListViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.enableContraints()
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let searchBar:UISearchBar  = {
        let searchBar = UISearchBar()
        searchBar.enableContraints()
        searchBar.placeholder = "Search Media Name"
        searchBar.backgroundImage = UIImage() // to remove top and bottom shadow
        return searchBar
    }()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.largeContentTitle = "Refreshing Media List"
        return refreshControl
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        return activityView
    }()
    
    //MARK: [END] PRIVATE variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.setupSearchBar()
        self.setupTableView()
        self.bindViewModel()
        self.viewModel.getTrackList()
    }
    
    
    ///This method binds viewModel to the views
    private func bindViewModel() {
        _ = self.tableView.rx.setDelegate(self)
        
        self.viewModel._showTracks.bind(to: tableView.rx.items(cellIdentifier: TrackCell.identifier , cellType: TrackCell.self)) { row, model, cell in
            cell.setUI(with: model)
        }.disposed(by: viewModel.disposeBag)
        
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(TrackModel.self))
            .bind { [weak self] indexPath, model in
                if let wSelf = self {
                    wSelf.tableView.deselectRow(at: indexPath, animated: true)
                    let vc = TrackDetailsViewController.create(model: model)
                    vc.didTapLike = { [weak self] model in
                        if let wSelf = self {
                            wSelf.viewModel.update(trackModel: model)
                        }
                    }
                    wSelf.navigationController?.pushViewController(vc, animated: true)
                }
            }.disposed(by: viewModel.disposeBag)
        
        self.viewModel.startLoading.drive(onNext: {  [weak self] start in
            guard let wSelf = self else { return }
            if start {
                if wSelf.refreshControl.isRefreshing {
                    return
                }
                wSelf.activityIndicator.center = wSelf.view.center
                wSelf.view.addSubview(wSelf.activityIndicator)
                wSelf.activityIndicator.startAnimating()
            }
        }).disposed(by: viewModel.disposeBag)
        
        self.viewModel.stopLoading.drive(onNext: { [weak self] stop in
            guard let wSelf = self else { return }
            if stop {
                wSelf.refreshControl.endRefreshing()
                wSelf.activityIndicator.removeFromSuperview()
            }
        }).disposed(by: viewModel.disposeBag)
        
        searchBar.searchTextField.rx.controlEvent([.editingChanged])
                .asObservable().subscribe({ [weak self] _ in
                    guard let wSelf = self else { return }
                    wSelf.viewModel.filterTracksByQuery(searchText: wSelf.searchBar.text ?? "")
                }).disposed(by: viewModel.disposeBag)
    }
    
    /// Instatiate SearchBar and set constraints
    private func setupSearchBar() {
        self.view.addSubview(searchBar)
        searchBar.anchor(top: self.view.layoutMarginsGuide.topAnchor,
                         bottom: nil,
                         leading: self.view.leadingAnchor,
                         trailing: self.view.trailingAnchor,
                         padding: .init(top: 4, left: 8, bottom: 4, right: 8),
                         size: .init(width: 0, height: 44))
    }
    
    /// Instatiate TableView and set constraints
    private func setupTableView() {
        // add tableview to view controller view
        self.view.addSubview(tableView)
        
        // set table view delegates and contraints
        tableView.register(TrackCell.self, forCellReuseIdentifier: TrackCell.identifier)
        tableView.anchor(top: searchBar.bottomAnchor,
                         bottom: self.view.bottomAnchor,
                         leading: self.view.leadingAnchor,
                         trailing: self.view.trailingAnchor)
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
    }
    
    /// Intialize UI
    private func initUI() {
        title = "Media"
        view.backgroundColor = .white
    }
    
    
    /// Triggered when heart button is tapped
    @objc private func refreshData(_ sender: Any) {
        // Fetch Data
        viewModel.getTrackList()
    }
}

//MARK: [START] UITABLEVIEW DELEGATE
extension TrackListViewController: UITableViewDelegate {
    
    // create header view to display last visited date
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let lastVisitDate = UserDefaults.standard.object(forKey: Constants.lastVisit) as? Date, let stringDate = lastVisitDate.string(output: "dd/MM/yyyy HH:mm") else { return nil }
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 20)
        let headerView = UIView(frame: frame)
        headerView.backgroundColor = .white
        let headerLabel = UILabel()
        headerLabel.font = UIFont.systemFont(ofSize: 15)
        headerLabel.enableContraints()
        headerLabel.text = "Last visited: " +  stringDate
        headerView.addSubview(headerLabel)
        headerLabel.anchor(leading: headerView.leadingAnchor, trailing: headerView.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        headerLabel.centerVertical(to: headerView)
        return headerView
    }
    
    // set header view height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = UserDefaults.standard.object(forKey: Constants.lastVisit) as? Date else {
            return 0
        }
        return 20
    }
}
//MARK: [END] UITABLEVIEW DELEGATE
