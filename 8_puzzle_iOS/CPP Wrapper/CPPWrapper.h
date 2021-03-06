//
//  CPPWrapper.h
//  8_puzzle_iOS
//
//  Created by Abdalla Elsaman on 11/16/20.
//  Copyright © 2020 Dumbies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPPWrapper : NSObject

- (void) bfs:(NSString *)initial;
- (void) dfs:(NSString *)initial;
- (void) AStarEuclidean:(NSString *)initial;
- (void) AStarManhattan:(NSString *)initial;
- (NSMutableArray *) generatedSteps;
- (NSString *)expandedNodes;



@end
