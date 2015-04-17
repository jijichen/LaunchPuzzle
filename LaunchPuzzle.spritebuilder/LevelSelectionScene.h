//
// Created by Yizhe Chen on 4/17/15.
// Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Constants.h"

@interface LevelSelectionScene : CCNode
- (instancetype)initWithLevelButtons:(NSMutableArray *)aLevelButtons;

+ (instancetype)sceneWithLevelButtons:(NSMutableArray *)aLevelButtons;

- (NSString *)description;



@end