//
//  Solver.cpp
//  8_puzzle_iOS
//
//  Created by Abdalla Elsaman on 11/16/20.
//  Copyright © 2020 Dumbies. All rights reserved.
//

#include "Solver.hpp"


using namespace std;

unordered_map<int, pair<int, int>> indecies = {
    {0, make_pair(0, 0)},
    {1, make_pair(1, 0)},
    {2, make_pair(2, 0)},
    {3, make_pair(0, 1)},
    {4, make_pair(1, 1)},
    {5, make_pair(2, 1)},
    {6, make_pair(0, 2)},
    {7, make_pair(1, 2)},
    {8, make_pair(2, 2)},
};




bool Solver::isValidIndex(int index) {
    return index < 9 && index >= 0;
}

vector<Node*> Solver::getNeighborsFrom(Node *node) {
    vector<Node *> neighbors;
    int emptyIndex = node->emptyIndex();
    // swap right
    if ((emptyIndex != 2 && emptyIndex != 5 && emptyIndex != 8) &&
        isValidIndex(emptyIndex+1)) {
        Node *newNode = new Node(node->val, node->depth+1, node);
        newNode->swap(emptyIndex, emptyIndex+1);
        neighbors.push_back(newNode);
    }
    // swap left
    if ((emptyIndex != 0 && emptyIndex != 3 && emptyIndex != 6) &&
        isValidIndex(emptyIndex-1)) {
        Node *newNode = new Node(node->val, node->depth+1, node);
        newNode->swap(emptyIndex, emptyIndex-1);
        neighbors.push_back(newNode);
    }
    // swap down
    if (isValidIndex(emptyIndex+3)) {
        Node *newNode = new Node(node->val, node->depth+1, node);
        newNode->swap(emptyIndex, emptyIndex+3);
        neighbors.push_back(newNode);
    }
    // swap up
    if (isValidIndex(emptyIndex-3)) {
        Node *newNode = new Node(node->val, node->depth+1, node);
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
    cout << steps.size() - 1 << " Steps" << endl;
    reverse(steps.begin(), steps.end());
    
    for (auto step: steps) {
        //            cout << step << endl;
    }
}

void Solver::bfs(Node *initial) {
    queue<Node *> frontier;
    frontier.push(initial);
    isVisited.insert(initial->val);
    while (!frontier.empty()) {
        Node *currentNode = frontier.front(); frontier.pop();
        if (currentNode->val == GOAL) {
            expandedNodes = to_string(isVisited.size());
            cout << "search depth " << currentNode->depth << endl;
            printSolution(currentNode);
            cout << "nodes expanded " << isVisited.size() << endl;
            return;
        }
        vector<Node *> neighbors = getNeighborsFrom(currentNode);
        for (auto neighbor: neighbors) {
            if (isVisited.find(neighbor->val) == isVisited.end()) {
                isVisited.insert(neighbor->val);
                frontier.push(neighbor);
            }
        }
    }
}

void Solver::AStarEuclidean(Node* initial) {
    set<pair<int, Node *>> frontier;
    frontier.insert(make_pair(0 + euclidean(initial->val) , initial));
    while (!frontier.empty()) {
        pair<int, Node *> currentPair = *frontier.begin();
        frontier.erase(currentPair);
        Node *currentNode = currentPair.second;
        
        isVisited.insert(currentNode->val);
        
        if (currentNode->val == GOAL) {
            expandedNodes = to_string(isVisited.size());
            cout << "path cost " << currentNode->f << endl;
            cout << "search depth " << currentNode->depth << endl;
            printSolution(currentNode);
            cout << "nodes expanded " << isVisited.size() << endl;
            return;
        }
        
        vector<Node *> neighbors = getNeighborsFrom(currentNode);
        
        for (auto neighbor: neighbors) {
            if (isVisited.find(neighbor->val) == isVisited.end() && frontier.find(make_pair(neighbor->f, neighbor)) == frontier.end()) {
                int f = neighbor->depth + euclidean(neighbor->val);
                neighbor->f = f;
                frontier.insert(make_pair(f, neighbor));
            } else if (frontier.find(make_pair(neighbor->f, neighbor)) != frontier.end()) {
                int oldCost = neighbor->f;
                int newCost = neighbor->depth + euclidean(neighbor->val);
                if (newCost < oldCost) {
                    frontier.erase(make_pair(oldCost, neighbor));
                    neighbor->f = newCost;
                    frontier.insert(make_pair(newCost, neighbor));
                }
            }
        }
    }
}

void Solver::AStarManhattan(Node* initial) {
    set<pair<int, Node *>> frontier;
    frontier.insert(make_pair(0 + manhattan(initial->val) , initial));
    while (!frontier.empty()) {
        pair<int, Node *> currentPair = *frontier.begin();
        frontier.erase(currentPair);
        Node *currentNode = currentPair.second;
        
        isVisited.insert(currentNode->val);
        
        if (currentNode->val == GOAL) {
            expandedNodes = to_string(isVisited.size());
            cout << "path cost " << currentNode->f << endl;
            cout << "search depth " << currentNode->depth << endl;
            printSolution(currentNode);
            cout << "nodes expanded " << isVisited.size() << endl;
            return;
        }
        
        vector<Node *> neighbors = getNeighborsFrom(currentNode);
        
        for (auto neighbor: neighbors) {
            if (isVisited.find(neighbor->val) == isVisited.end() && frontier.find(make_pair(neighbor->f, neighbor)) == frontier.end()) {
                int f = neighbor->depth + manhattan(neighbor->val);
                neighbor->f = f;
                frontier.insert(make_pair(f, neighbor));
            } else if (frontier.find(make_pair(neighbor->f, neighbor)) != frontier.end()) {
                int oldCost = neighbor->f;
                int newCost = neighbor->depth + manhattan(neighbor->val);
                if (newCost < oldCost) {
                    frontier.erase(make_pair(oldCost, neighbor));
                    neighbor->f = newCost;
                    frontier.insert(make_pair(newCost, neighbor));
                }
            }
        }
    }
}


int Solver::manhattan(string val) {
    unordered_map<int, pair<int, int>> map;
    int dis = 0;
    for (int i = 0; i < 9; i++) {
        int dx = abs(indecies[i].first - indecies[val[i] - 48].first);
        int dy = abs(indecies[i].second - indecies[val[i] - 48].second);
        dis += dx + dy;
    }
    return dis;
}

int Solver::euclidean(string val) {
    int dis = 0;
    for (int i = 0; i < 9; i++) {
        int dx = abs(indecies[i].first - indecies[val[i] - 48].first);
        int dy = abs(indecies[i].second - indecies[val[i] - 48].second);
        dis += sqrt(dx*dx + dy*dy);
    }
    return dis;
}

void Solver::dfs(Node* initial) {
    stack<Node *> frontier;
    frontier.push(initial);
    while (!frontier.empty()) {
        Node *currentNode = frontier.top(); frontier.pop();
        isVisited.insert(currentNode->val);
        if (currentNode->val == GOAL) {
            expandedNodes = to_string(isVisited.size());
            cout << "search depth " << currentNode->depth << endl;
            printSolution(currentNode);
            cout << "nodes expanded " << isVisited.size() << endl;
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
