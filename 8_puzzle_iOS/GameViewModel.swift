//
//  GameViewModel.swift
//  8_puzzle_iOS
//
//  Created by Abdalla Elsaman on 11/16/20.
//  Copyright © 2020 Dumbies. All rights reserved.
//

import Foundation

class GameViewModel {
    private let cppWrapper = CPPWrapper()
    var algorithmType = AlgorithmType.bfs
    var solutionSteps = [[NumberData]]()
    var runTime = ""
    var expandedNodes = ""
    var stepsCount = ""
    var numberDataList = [
        NumberData(labelName: "1"),
        NumberData(labelName: "8"),
        NumberData(labelName: "2"),
        NumberData(labelName: "0"),
        NumberData(labelName: "4"),
        NumberData(labelName: "3"),
        NumberData(labelName: "7"),
        NumberData(labelName: "6"),
        NumberData(labelName: "5")
    ]

    private func toString(from list: [NumberData]) -> String {
        var str = String()
        for numberData in numberDataList {
            str.append(numberData.labelName)
        }
        return str
    }

    func generateSolution() {
        let dataListString = toString(from: numberDataList)
        let start = CFAbsoluteTimeGetCurrent()
        switch algorithmType {
        case .bfs:
            cppWrapper.bfs(dataListString)
        case .dfs:
            cppWrapper.dfs(dataListString)
        case .aStarManhattan:
            cppWrapper.aStarManhattan(dataListString)
        case .aStarEuclidean:
            cppWrapper.aStarEuclidean(dataListString)
        }
        runTime = String(String(CFAbsoluteTimeGetCurrent() - start).prefix(6))
        expandedNodes = cppWrapper.expandedNodes()
        let states = cppWrapper.generatedSteps() as! [String]
        stepsCount = String(states.count)
        for state in states {
            let newState = [
                NumberData(labelName: state[0]),
                NumberData(labelName: state[1]),
                NumberData(labelName: state[2]),
                NumberData(labelName: state[3]),
                NumberData(labelName: state[4]),
                NumberData(labelName: state[5]),
                NumberData(labelName: state[6]),
                NumberData(labelName: state[7]),
                NumberData(labelName: state[8])
            ]
            solutionSteps.append(newState)
        }
    }
}

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

struct NumberData: Hashable {
    var labelName: String
}

enum AlgorithmType {
    case bfs
    case dfs
    case aStarEuclidean
    case aStarManhattan
}
