//
// Created by Yizhe Chen on 4/17/15.
// Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCBSequenceProperty.h"


@interface GameStateSingleton : NSObject{
    NSMutableDictionary *_levelStars;
    NSInteger _unlockedTo;
}

+ (GameStateSingleton*) getInstance;

- (GameStateSingleton*) init;
- (void) saveToDefault;
- (void) loadFromDefault;
- (NSInteger) count;

@property(atomic) NSInteger unlockedTo;
@property(atomic) NSMutableDictionary * levelStars;
@property(atomic) Boolean tutorialShown;

@end