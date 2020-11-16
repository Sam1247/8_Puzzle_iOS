//
//  Solver.cpp
//  8_puzzle_iOS
//
//  Created by Abdalla Elsaman on 11/16/20.
//  Copyright © 2020 Dumbies. All rights reserved.
//

#include "Solver.hpp"


using namespace std;


bool Solver::isValidIndex(int index) {
    return index < 9 && index >= 0;
}

vector<Node*> Solver::getNeighborsFrom(Node *node) {
    vector<Node *> neighbors;
    int emptyIndex = node->emptyIndex();
    // swap right
    if ((emptyIndex != 2 && emptyIndex != 5 && emptyIndex != 8) &&
        isValidIndex(emptyIndex+1)) {
        Node *newNode = new Node(node->val, node);
        newNode->swap(emptyIndex, emptyIndex+1);
        neighbors.push_back(newNode);
    }
    // swap left
    if ((emptyIndex != 0 && emptyIndex != 3 && emptyIndex != 6) &&
        isValidIndex(emptyIndex-1)) {
        Node *newNode = new Node(node->val, node);
        newNode->swap(emptyIndex, emptyIndex-1);
        neighbors.push_back(newNode);
    }
    // swap down
    if (isValidIndex(emptyIndex+3)) {
        Node *newNode = new Node(node->val, node);
        newNode->swap(emptyIndex, emptyIndex+3);
        neighbors.push_back(newNode);
    }
    // swap up
    if (isValidIndex(emptyIndex-3)) {
        Node *newNode = new Node(node->val, node);
        newNode->swap(emptyIndex, emptyIndex-3);
        neighbors.push_back(newNode);
    }
    return neighbors;
}

void Solver::printSolution(Node *node) {
    Node *currentNode = node;
    while (currentNode != nullptr) {
        steps.push_back(currentNode->val);
        currentNode = currentNode->previous;
    }
    reverse(steps.begin(), steps.end());
    for (auto step: steps) {
        cout << step << endl;
    }
    cout << endl << steps.size() << endl;
}

void Solver::bfs(Node *initial) {
    queue<Node *> frontier;
    frontier.push(initial);
    while (!frontier.empty()) {
        Node *currentNode = frontier.front(); frontier.pop();
        isVisited.insert(currentNode->val);
        if (currentNode->val == GOAL) {
            printSolution(currentNode);
            return;
        }
        vector<Node *> neighbors = getNeighborsFrom(currentNode);
        for (auto neighbor: neighbors) {
            if (isVisited.find(neighbor->val) == isVisited.end()) {
                frontier.push(neighbor);
            }
        }
    }
}

void Solver::dfs(Node* initial) {
    stack<Node *> frontier;
    frontier.push(initial);
    while (!frontier.empty()) {
        Node *currentNode = frontier.top(); frontier.pop();
        isVisited.insert(currentNode->val);
        if (currentNode->val == GOAL) {
            printSolution(currentNode);
            return;
        }
        vector<Node *> neighbors = getNeighborsFrom(currentNode);
        for (auto neighbor: neighbors) {
            if (isVisited.find(neighbor->val) == isVisited.end()) {
                frontier.push(neighbor);
            }
        }
    }
}
