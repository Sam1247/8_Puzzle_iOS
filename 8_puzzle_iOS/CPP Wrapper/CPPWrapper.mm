//
//  CPPWrapper.m
//  8_puzzle_iOS
//
//  Created by Abdalla Elsaman on 11/16/20.
//  Copyright © 2020 Dumbies. All rights reserved.
//

#import "CPPWrapper.h"
#import "Solver.hpp"

@implementation CPPWrapper
{
    Solver *_solver;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _solver = new Solver();
        return self;
    }
    return self;
}

- (NSString *)expandedNodes
{
    return @(_solver->expandedNodes.c_str());
}

- (void)bfs:(NSString *)initial
{
    Node *initialNode = new Node(string([initial UTF8String]), 0, nullptr);
    _solver->bfs(initialNode);
}

- (void)dfs:(NSString *)initial
{
    Node *initialNode = new Node(string([initial UTF8String]), 0, nullptr);
    _solver->dfs(initialNode);
}

- (void)AStarEuclidean:(NSString *)initial
{
    Node *initialNode = new Node(string([initial UTF8String]), 0, nullptr);
    _solver->AStarEuclidean(initialNode);
}

- (void)AStarManhattan:(NSString *)initial
{
    Node *initialNode = new Node(string([initial UTF8String]), 0, nullptr);
    _solver->AStarManhattan(initialNode);
}

- (NSMutableArray *)generatedSteps
{
    int stepsCount = int(_solver->steps.size());
    NSMutableArray* steps = [NSMutableArray new];
    for (int i = 0; i < stepsCount; i++) {
        [steps addObject:@(_solver->steps[i].c_str())];
    }
    return steps;
}

-(void)dealloc {
    puts("De-allocating CPP Solver.");
    delete _solver;
}

@end
