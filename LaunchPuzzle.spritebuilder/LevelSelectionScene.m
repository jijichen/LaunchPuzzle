//
// Created by Yizhe Chen on 4/17/15.
// Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LevelSelectionScene.h"
#import "LevelButton.h"
#import "GameScene.h"


@implementation LevelSelectionScene {
    NSMutableArray * levelButtons;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        levelButtons = [[NSMutableArray alloc] init];
    }

    return self;
}

+ (instancetype)sceneWithLevelButtons:(NSMutableArray *)aLevelButtons {
    return [[self alloc] initWithLevelButtons:aLevelButtons];
}

- (void) didLoadFromCCB {
    [self setUserInteractionEnabled:YES];

    for (int i = 1; i <= [Constants totalLevelCount]; i++) {
        [self loadLevel:i];
    }
}

- (void) loadLevel:(int) l {
    LevelButton* wBut = [[LevelButton alloc] init];
    CCSprite * wButSprite = [CCBReader load:@"Sprites/LevelButton" owner:wBut];
    NSString * levelStr = [[NSString alloc] initWithFormat:@"Level %d", l];

    wBut.level = l;
    [wBut.levelLabel setString:levelStr];
    //[wBut.button setTarget:wBut selector:@selector(playLevel:)];

    [wButSprite setAnchorPoint:CGPointMake(0.5, 0.5)];
    [wButSprite setPositionType:CCPositionTypeMake(CCPositionUnitNormalized, CCPositionUnitNormalized,
            CCPositionReferenceCornerTopLeft)];

    int page = (l - 1) / 9;
    int row = ((l - 1) % 9) / 3 + 1;
    int col = (l - 1) % 3 + 1;
    [wButSprite setPosition:CGPointMake(0.25 * col, 0.2 + 0.3 * (row - 1))];

    [levelButtons addObject:wBut];
    [self addChild:wButSprite];

}





@end