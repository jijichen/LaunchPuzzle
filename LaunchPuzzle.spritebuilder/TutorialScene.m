//
// Created by Yizhe Chen on 4/28/15.
// Copyright (c) 2015 Apportable. All rights reserved.
//

#import "TutorialScene.h"


@implementation TutorialScene {
    CCScrollView * _scrollView;
}

-(void) didLoadFromCCB {
    _scrollView = [CCScrollView scrollViewWithContentNode:self];
    _scrollView.delegate = self;
    _scrollView.contentSizeType = CCSizeTypePoints;
    _scrollView.contentSize = CGSizeMake(200, 200);
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    _scrollView.position = CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0);
    [self.parent addChild:_scrollView];

}
@end