//
//  ViewController.swift
//  8_puzzle_iOS
//
//  Created by Abdalla Elsaman on 11/15/20.
//  Copyright © 2020 Dumbies. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    enum Section {
      case main
    }
    let viewModel = GameViewModel()
    typealias DataSource = UICollectionViewDiffableDataSource<Section, NumberData>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, NumberData>
    private lazy var dataSource = makeDataSource()

    @IBOutlet var infoStackView: UIStackView! {
        didSet {
            infoStackView.alpha = 0
        }
    }
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var stepsLabel: UILabel!
    @IBOutlet var expandedNodesLabel: UILabel!
    @IBOutlet var runtimeLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    @IBOutlet var solveButton: UIButton! {
        didSet {
            solveButton.layer.cornerRadius = 12
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        applySnapshot(completion: nil)
        spinner.hidesWhenStopped = true
    }

    func animateTest() {
        viewModel.numberDataList = viewModel.solutionSteps[1]
        applySnapshot(animatingDifferences: true, completion: nil)
    }

    func animate(index: Int) {
        if (index == viewModel.solutionSteps.count) {
            updateInfoStack()
            return
        }
        viewModel.numberDataList = viewModel.solutionSteps[index]
        self.applySnapshot(animatingDifferences: true) {
            self.animate(index: index+1)
        }
    }

    func updateInfoStack() {
        UIView.animate(withDuration: 0.2) {
            self.infoStackView.alpha = 1
            self.stepsLabel.text = self.viewModel.stepsCount
            self.expandedNodesLabel.text = self.viewModel.expandedNodes
            self.runtimeLabel.text = self.viewModel.runTime
        }
    }

    @IBAction func solve(_ sender: Any) {
        spinner.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.viewModel.generateSolution()
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.solveButton.isEnabled = true
                self.animate(index: 1)
            }
        }
        solveButton.isEnabled = false
        print(#function)
    }
    
    @IBAction func algorithmTypeDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.algorithmType = .bfs
        case 1:
            viewModel.algorithmType = .dfs
        case 2:
            viewModel.algorithmType = .aStarEuclidean
        case 3:
            viewModel.algorithmType = .aStarManhattan
        default:
            viewModel.algorithmType = .bfs
        }
    }
    
    func applySnapshot(animatingDifferences: Bool = true, completion: (() -> Void)?) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.numberDataList)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }
    
    func makeDataSource() -> DataSource {
        // 1
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, numberData) ->
                UICollectionViewCell? in
                // 2
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "NumberCell",
                    for: indexPath) as? NumberCell
                cell?.numberLabel.text = numberData.labelName
                if numberData.labelName == "0" {
                    cell?.containerView.backgroundColor = .clear
                    cell?.numberLabel.text = ""
                }
                return cell
        })
        return dataSource
    }
    
    
}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as! NumberCell
        return cell
    }
}


// MARK: - Layout Handling
extension GameViewController {
    private func configureLayout() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalWidth(1/3))
            let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
            fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2)
            //2
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1/3))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: fullPhotoItem,
                count: 3
            )
            //3
            let section = NSCollectionLayoutSection(group: group)
            return section
        })
    }
}

