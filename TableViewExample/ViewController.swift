import UIKit

class ViewController: UIViewController {
    
    fileprivate let data = Language.make()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .plain
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private enum CellReuseID: String {
        case base = "BaseTableViewCell_ReuseID"
        case custom = "CustomTableViewCell_ReuseID"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        setupConstraints()
        tuneTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         
         tableView.indexPathsForSelectedRows?.forEach{ indexPath in
             tableView.deselectRow(
                 at: indexPath,
                 animated: animated
             )
         }
     }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "TableView Example"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
    }
    
    private func tuneTableView() {
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
        let headerView = TableHeaderView(title: "Языки программирования")
        tableView.setAndLayout(headerView: headerView)
        tableView.tableFooterView = UIView()
        
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: CellReuseID.base.rawValue)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CellReuseID.custom.rawValue)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        data.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UITableViewCell {
        
        if indexPath.row == data.count {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellReuseID.custom.rawValue,
                for: indexPath
            ) as? CustomTableViewCell else {
                fatalError("could not dequeueReusableCell")
            }
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellReuseID.base.rawValue,
            for: indexPath
        ) as? BaseTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        
        cell.update(data[indexPath.row])
        
        return cell
        
    }
}

extension ViewController: UITableViewDelegate {}
