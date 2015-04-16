//
//  Level.m
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Level.h"

@implementation Level

- (void)didLoadFromCCB {
    self.presetObjs = self->_children;
    NSMutableArray *bombs = [[NSMutableArray alloc] init];
    NSMutableArray *plates = [[NSMutableArray alloc] init];
    int c = 0;
    for (CCNode *preObj in self.presetObjs) {
        [preObj setUserInteractionEnabled:NO];
        if ([preObj.name  isEqual: @"Target"]){
            c += 1;
        } else if ([[[preObj physicsBody] collisionType] isEqual:@"Plate"]) {
            [plates addObject:preObj];
        } else if ([[[preObj physicsBody] collisionType] isEqual:@"Bomb"]) {
            [bombs addObject:preObj];
        }
    }
    self.targetCount = c;
    self.presetBombs = [bombs copy];
    self.presetPlate = [plates copy];
}

@end
