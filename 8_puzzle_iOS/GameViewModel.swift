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
    var solutionSteps = [[NumberData]]()
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
    
    func generateSolution() {
        cppWrapper.bfs("182043765");
        let states = cppWrapper.generatedSteps() as! [String]
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
