//
//  DiffableViewController.swift
//  Diffable
//
//  Created by Vladimir Ho on 20.12.2019.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import UIKit

class DiffableViewController: UIViewController {

    enum Section: CaseIterable {
        case main
    }
    let employeeModel = EmployeeModel()
    let searchBar = UISearchBar(frame: .zero)
    var employeeCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, EmployeeModel.Employee>!
    var nameFilter: String?

    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Diffable 😎"
        configureHierarchy()
        configureDataSource()
        performQuery(with: nil)
    }
}

extension DiffableViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
            <Section, EmployeeModel.Employee>(collectionView: employeeCollectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath,
                mountain: EmployeeModel.Employee) -> UICollectionViewCell? in
            guard let mountainCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LabelCell.reuseIdentifier, for: indexPath) as? LabelCell else {
                    fatalError("Cannot create new cell") }
            mountainCell.label.text = mountain.name + ". Отдел " + mountain.height
            return mountainCell
        }
    }
    func performQuery(with filter: String?) {
        let employees = employeeModel.filteredEmployees(with: filter).sorted { $0.name < $1.name }

        var snapshot = NSDiffableDataSourceSnapshot<Section, EmployeeModel.Employee>()
        snapshot.appendSections([.main])
        snapshot.appendItems(employees)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension DiffableViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let contentSize = layoutEnvironment.container.effectiveContentSize
            let columns = contentSize.width > 800 ? 3 : 2
            let spacing = CGFloat(10)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(32))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1) // CHANGE COUNT COLUMNS HERE 😎
            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

            return section
        }
        return layout
    }

    func configureHierarchy() {
        view.backgroundColor = .systemBackground
        let layout = createLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(LabelCell.self, forCellWithReuseIdentifier: LabelCell.reuseIdentifier)
        view.addSubview(collectionView)
        view.addSubview(searchBar)

        let views = ["cv": collectionView, "searchBar": searchBar]
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[cv]|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[searchBar]|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "V:[searchBar]-20-[cv]|", options: [], metrics: nil, views: views))
        constraints.append(searchBar.topAnchor.constraint(
            equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0))
        NSLayoutConstraint.activate(constraints)
        employeeCollectionView = collectionView

        searchBar.delegate = self
    }
}

extension DiffableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.hideLoading()
            self.performQuery(with: searchText)
            if searchText.isEmpty {
                searchBar.endEditing(true)
            }
        }
    }
}

extension DiffableViewController {
    
    func showLoading() {
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func hideLoading() {
        alert.dismiss(animated: true)
    }
}

