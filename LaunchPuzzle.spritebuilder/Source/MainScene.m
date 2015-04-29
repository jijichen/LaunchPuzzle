#import "MainScene.h"
#import "GameScene.h"
#import "FBViewController.h"
#import "TutorialScene.h"


@implementation MainScene


-(void) play {
    [MainScene playMenu];
}

+(void) playMenu {
    CCScene *scene = [CCBReader loadAsScene:@"SelectLevelScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}


@end
