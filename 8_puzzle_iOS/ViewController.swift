//
//  ViewController.swift
//  8_puzzle_iOS
//
//  Created by Abdalla Elsaman on 11/15/20.
//  Copyright © 2020 Dumbies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    enum Section {
      case main
    }
    private var numberDataList = [
        NumberData(labelName: ""),
        NumberData(labelName: "1"),
        NumberData(labelName: "2"),
        NumberData(labelName: "3"),
        NumberData(labelName: "4"),
        NumberData(labelName: "5"),
        NumberData(labelName: "6"),
        NumberData(labelName: "7"),
        NumberData(labelName: "8"),
    ]
    typealias DataSource = UICollectionViewDiffableDataSource<Section, NumberData>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, NumberData>
    private lazy var dataSource = makeDataSource()

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
        let cppWrapper = CPPWrapper()
        cppWrapper.bfs("182043765")
        configureLayout()
        applySnapshot(completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.numberDataList.swapAt(0, 1)
            self.applySnapshot(animatingDifferences: true) {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.animate()
                }
            }
        }
    }

    func animate() {
        self.numberDataList.swapAt(0, 1)
        self.applySnapshot(animatingDifferences: true) {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.animate()
            }
        }
    }
    
    @IBAction func solve(_ sender: Any) {
        print(#function)
    }
    func applySnapshot(animatingDifferences: Bool = true, completion: (() -> Void)?) {
        // 2
        var snapshot = Snapshot()
        // 3
        snapshot.appendSections([.main])
        // 4
        snapshot.appendItems(numberDataList)
        // 5
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
                if numberData.labelName == "" {
                    cell?.containerView.backgroundColor = .clear
                }
                return cell
        })
        return dataSource
    }
    
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as! NumberCell
        return cell
    }
}


// MARK: - Layout Handling
extension ViewController {
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

struct NumberData: Hashable {
    var id = UUID()
    var labelName: String
}
