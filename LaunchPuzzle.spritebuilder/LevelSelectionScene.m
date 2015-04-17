//
// Created by Yizhe Chen on 4/17/15.
// Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LevelSelectionScene.h"
#import "LevelButton.h"
#import "GameScene.h"
#import "GameStateSingleton.h"


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
    GameStateSingleton * state = [GameStateSingleton getInstance];

    LevelButton* wBut = [[LevelButton alloc] init];
    CCSprite * wButSprite = [CCBReader load:@"Sprites/LevelButton" owner:wBut];
    [wButSprite setAnchorPoint:CGPointMake(0.5, 0.5)];
    [wButSprite setPositionType:CCPositionTypeMake(CCPositionUnitNormalized, CCPositionUnitNormalized,
            CCPositionReferenceCornerTopLeft)];
    NSString * levelStr = [[NSString alloc] initWithFormat:@"Level %d", l];
    [wBut.levelLabel setString:levelStr];
    wBut.level = l;
    int row = ((l - 1) % 9) / 3 + 1;
    int col = (l - 1) % 3 + 1;
    [wButSprite setPosition:CGPointMake(0.25 * col, 0.2 + 0.3 * (row - 1))];

    [levelButtons addObject:wBut];
    [self addChild:wButSprite];

    if (l > state.unlockedTo) {
        //[wButSprite setUserInteractionEnabled:NO];
        [wBut.locker setVisible:YES];
        [wBut.button setUserInteractionEnabled:NO];
    }

    NSNumber * stars = [state.levelStars objectForKey:[NSNumber numberWithInt:l]];
    if (stars == nil) {
        stars = 0;
    }

    if ([stars intValue] > 2) {
        [wBut.star3 setVisible:YES];
    }
    if ([stars intValue] > 1) {
        [wBut.star2 setVisible:YES];
    }
    if ([stars intValue] > 0) {
        [wBut.star1 setVisible:YES];
    }



}





@end