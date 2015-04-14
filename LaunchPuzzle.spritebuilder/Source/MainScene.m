#import "MainScene.h"
#import "GameScene.h"

@implementation MainScene

-(void)play {
    CCScene *scene = [CCBReader loadAsScene:@"GameScene"];
    //[gameScene setCurrentLevel:1];
    GameScene *gameScene = (GameScene *)[scene.children objectAtIndex:0];
    [gameScene loadLevel:[Constants startLevel]];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
