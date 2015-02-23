#Game Design

##Objective

Collect all stars and Gems in each level.
## Gameplay Mechanics
The game is set up in overhead view, the play scen is a 2D plane. The stars or gems are distributed in the play scene, also some barrier and bombs are distributed in the scene.
The collector is a plate which can be launched by touch and slide in different directions.
Players would at first place some barrier himself to help change the route of the plate.


## Level Design
Each level is a single play scene. With a possible solution route in mind, some barriers were removed and left for user to place on the scenes.

Since we need to do a slide and lunch of the plate, the level should be in vertial mode. And the boundary of the scene is not solid.

#Technical
##Scenes
- Main Menu
- Level Select
- Play scene

##Controls/Input
- Slide based
- Touch to place barrier and use two finger to spin

##Classes/CCBs
- Scences
  - Main Menu
  - Level Select
  - GamePlay
- Nodes/Sprites
  - Plate
  - Barrier
    - Different kinds of barrier
  - Gems

#MVP Milestones
## Week 1 (2/16 - 2/22/2015)
- implement physics on plate and barrier
- plate move by sliding
- Fisrt build of game

## Week 2 (2/23 - 3/1/2015)
- Refine first level
- Refine physics and interactions
- add put barrier function

## Week 3 (3/2 - 3/8/2015)
- Add main scene
- Connect main scene to the play scene
- Add spin funciton

## Week 4 (3/9 - 3/15/2015)
- Keep state of the levels
- Design more level

## Week 5 (3/16 - 3/22/2015)
- Refine UI

## Week 6 (3/23 - 3/29/2015)
- Finish up
