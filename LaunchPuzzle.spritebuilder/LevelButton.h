//
// Created by Yizhe Chen on 4/17/15.
// Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LevelButton : CCNode

-(void) playLevel;

@property CCLabelTTF* levelLabel;
@property int level;
@property CCButton* button;
@property CCNode* star1;
@property CCNode* star2;
@property CCNode* star3;

@end