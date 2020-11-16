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

- (void)bfs:(NSString *)initial
{
    Node *initialNode = new Node(string([initial UTF8String]), nullptr);
    _solver->bfs(initialNode);
}

- (void)dfs:(NSString *)initial
{
    Node *initialNode = new Node(string([initial UTF8String]), nullptr);
    _solver->dfs(initialNode);
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
