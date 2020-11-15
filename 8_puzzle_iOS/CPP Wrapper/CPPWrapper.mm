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


- (void)bfs:(NSString *)initial
{
    Solver solver = Solver();
    Node *initialNode = new Node(string([initial UTF8String]), nullptr);
    solver.bfs(initialNode);
}

- (void)dfs:(NSString *)initial
{
    Solver solver = Solver();
    Node *initialNode = new Node(string([initial UTF8String]), nullptr);
    solver.dfs(initialNode);
}

@end
