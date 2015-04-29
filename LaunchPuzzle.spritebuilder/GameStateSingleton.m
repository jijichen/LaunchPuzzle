//
// Created by Yizhe Chen on 4/17/15.
// Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameStateSingleton.h"


@implementation GameStateSingleton {

}

static GameStateSingleton* singletonInstance;
static NSString* const STARS_KEY = @"levelStar";
static NSString* const UNLOCKINT_KEY = @"unlockUpto";
static NSString* const TUTORIALSHOWN_KEY = @"tutorialShown";


+ (GameStateSingleton*) getInstance {
    if (singletonInstance == NULL) {
        singletonInstance = [[self alloc] init];
    }
    return singletonInstance;
}

- (GameStateSingleton*) init {
    self = [super init];
    if (self) {
        _levelStars = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) saveToDefault {
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:_levelStars];
    [userDefault setObject:encodedObject forKey:STARS_KEY];
    [userDefault setInteger:_unlockedTo forKey:UNLOCKINT_KEY];
    [userDefault setBool:_tutorialShown forKey:TUTORIALSHOWN_KEY];
    [userDefault synchronize];
}

-(void) loadFromDefault {
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [userDefault objectForKey:STARS_KEY];
    if (encodedObject != nil) {
        _levelStars = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }

    _unlockedTo = [userDefault integerForKey:UNLOCKINT_KEY];
    if (_unlockedTo == nil) {
        _unlockedTo = 1;
    }

    _tutorialShown = [userDefault boolForKey:TUTORIALSHOWN_KEY];
    if (_tutorialShown == nil) {
        _tutorialShown = NO;
    }
}

@end