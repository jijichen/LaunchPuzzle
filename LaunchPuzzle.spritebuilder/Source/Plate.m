//
//  PlateTool.m
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Plate.h"

@implementation Plate

- (void) didLoadFromCCB {
    self.physicsBody.collisionType = @"Plate";
    self.name = @"Plate";
}
@end
