//
//  Solver.hpp
//  8_puzzle_iOS
//
//  Created by Abdalla Elsaman on 11/16/20.
//  Copyright © 2020 Dumbies. All rights reserved.
//

#ifndef Solver_hpp
#define Solver_hpp

#include <stdio.h>
#include <iostream>
#include <unordered_set>
#include <unordered_map>
#include <algorithm>
#include <iostream>
#include <stack>
#include <set>
#include <queue>
#define GOAL "012345678"
#endif /* Solver_hpp */

using namespace std;

struct Node {
    string val;
    Node *previous;
    int depth;
    int f;
    Node(string val, int depth, Node *previous) : val(val), depth(depth), previous(previous) {
        f = INT_MAX;
    }

    int emptyIndex() {
        int emptyIndex = -1;
        for (int i = 0; i < val.size(); i++) {
            if (val[i] == '0') {
                emptyIndex = i;
            }
        }
        assert(emptyIndex != -1);
        return emptyIndex;
    }

    void swap(int index1, int index2) {
        int temp = val[index1];
        val[index1] = val[index2];
        val[index2] = temp;
    }
};


class Solver
{
private:
    int manhattan(string val);
    int euclidean(string val);
    unordered_set<string> isVisited;
    Node *solutionNode = nullptr;
    bool isValidIndex(int index);
    vector<Node*> getNeighborsFrom(Node *node);
public:
    vector<string> steps;
    void printSolution(Node *node);
    void AStar(Node *initial);
    void bfs(Node* initial);
    void dfs(Node* initial);
};
