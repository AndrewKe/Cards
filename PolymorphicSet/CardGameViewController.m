//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Andrew Ke on 9/23/13.
//  Copyright (c) 2013 Andrew Ke. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "CardMatchingGame.h"
//#import "GameResult.h"

@interface CardGameViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
//@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;
//@property (strong, nonatomic) GameResult *gameResult;
@property (strong, nonatomic) NSMutableArray *cardDistanceFromCenter;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collision;
@property (strong, nonatomic) UIView *pileView;
@property (strong, nonatomic) NSValue *conatinerCenter;
@end

@implementation CardGameViewController

#pragma mark - initiation
- (CardMatchingGame *)game
{
    if(!_game){
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count                                                  usingDeck:[self getDeck]];
    }
    _game.useAttributedText = self.useAttributedText;
    return _game;
}

- (UIDynamicAnimator *) animator{
    if(!_animator){
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        _animator.delegate = self;
    }
    return _animator;
}

- (UICollisionBehavior *)collision{
    if(!_collision){
        _collision = [[UICollisionBehavior alloc] init];
        _collision.translatesReferenceBoundsIntoBoundary = YES;
        [self.animator addBehavior:_collision];
    }
    return _collision;
}
- (UIGravityBehavior *) gravity{
    if(!_gravity){
        _gravity = [[UIGravityBehavior alloc]init];
        [self.animator addBehavior:_gravity];
        _gravity.magnitude = 1;
    }
    return  _gravity;
}

#pragma mark - View Controller Lifecycle

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateUI];
    [self relayoutButtons];
}

- (void) awakeFromNib{
    [super awakeFromNib];
    UIPinchGestureRecognizer *p = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [self.view addGestureRecognizer:p];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    tap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tap];
    UIPanGestureRecognizer *pan =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    [self relayoutButtons];
    self.conatinerCenter = [NSValue valueWithCGPoint:self.cardContainer.center];
}




# pragma mark - Pinch Gather Drop
- (IBAction)pinch:(UIPinchGestureRecognizer *)sender {
    int changeFactor = 50;
    self.pileView = [[UIView alloc] init];
    [self.cardContainer addSubview:self.pileView];
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         if(sender.state == UIGestureRecognizerStateBegan){
                             for(UIView *v in self.cardButtons){
                                 v.alpha = 0.94;
                                 v.center = CGPointMake(self.cardContainer.center.x + changeFactor - arc4random()%(2*changeFactor), self.cardContainer.center.y + changeFactor - arc4random()%(2*changeFactor));
                             }
                         }
                     }completion:NULL];

}

- (IBAction)doubleTapped:(UITapGestureRecognizer *)sender{
        NSLog(@"Resolving cards");
        [self.gravity addItem: self.cardContainer ];
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            //[self.gravity removeItem:self.cardContainer];
            //self.cardContainer.center = CGPointMake(150, 260);
            for(UIView *v in self.cardButtons){
                v.alpha = 1;
            }
            [self relayoutButtons];
        }
        completion:^(BOOL b){
            [self.gravity removeItem:self.cardContainer];
            [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionAllowAnimatedContent
                             animations:^{
                                 self.cardContainer.center = CGPointMake(self.view.center.x, self.cardContainer.bounds.size.height/2 + 20 );
                             }completion:NULL];
                         }];
        self.pileView = nil;


}

- (IBAction)pan:(UIPanGestureRecognizer *)sender{
    CGPoint gesturePoint = [sender locationInView:self.view];
    //self.gravity = nil;
    //self.collision = nil;
    if(self.pileView){
        if(sender.state == UIGestureRecognizerStateBegan){
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                self.cardContainer.center = gesturePoint;
            }completion:NULL];

        }else if(sender.state == UIGestureRecognizerStateChanged){
            self.cardContainer.center = gesturePoint;
        }else if (sender.state == UIGestureRecognizerStateEnded){
        }
    }


}

#pragma mark - Card Flipping
- (void) setFlipCount:(int)flipCount{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}
- (IBAction)flipCard:(UIView *)sender {
    NSLog(@"Flipping Card");
    [self.game flipCardAtIndex: [self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [UIView transitionWithView:sender duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                            [self updateUI];
                    }
                    completion:NULL];
    //self.gameResult.score = self.game.score;
}

- (void)viewTapped:(UIView *)view {
    NSLog(@"View Tapped");
    [self flipCard:view];
}

# pragma mark - Graphics

- (IBAction)dealPressed {
        [UIView animateWithDuration:0.35
                              delay:0
                            options: UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             self.cardContainer.center = CGPointMake(self.cardContainer.center.x, self.cardContainer.center.y+ 2 * self.cardContainer.frame.size.height);
                             //self.buttonContainer.center = CGPointMake(50, -300);
                         }completion:^(BOOL completed){
                             if (completed) {
                                 for (UIView *b in self.cardButtons){
                                     b.alpha = 1;
                                     [(id)b setEnabled:true];
                                     //b.enabled = true;
                                     //b.selected = false;
                                 }
                                 BOOL oldExtreme = self.game.extreme;
                                 self.game = nil;
                                 self.flipCount = 0;
                                 [self updateUI];
                                 
                                 [self relayoutButtons];
                                 self.game.extreme = oldExtreme;
                                 self.cardContainer.center = CGPointMake(self.cardContainer.center.x, self.cardContainer.center.y- 4 * self.cardContainer.frame.size.height);
                                 [UIView animateWithDuration:0.35
                                                       delay:0
                                                     options: UIViewAnimationOptionAllowAnimatedContent
                                                  animations:^{
                                                      self.cardContainer.center = CGPointMake(self.cardContainer.center.x, self.cardContainer.center.y + 2* self.cardContainer.frame.size.height);
                                                  }completion:^(BOOL completed){
                                                  }];
                             }
                         }];
}



- (void)updateUI
{
    if(self.game.useAttributedText){
        self.game.extreme = true;
    }
    
    BOOL relayout = false;
    for (int i =0; i<self.cardButtons.count; i++){
        UIView *cardButton = self.cardButtons[i];
        ///NSLog(@"Button: %@ at Index : %lu", cardButton, (unsigned long)[self.cardButtons indexOfObject:cardButton]);
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        if(self.useAttributedText){
            //NSLog(@"Contents: %@", card.label.string);
            [(id)cardButton setAttributedTitle:card.label forState:UIControlStateNormal];
        }else{
            [(id)cardButton setTitle:card.contents forState:UIControlStateSelected];
        }
        [(id)cardButton setSelected: card.isFaceUp];
        //__block UIButton *scardButton = cardButton;
        if(card.isUnplayable && cardButton.alpha>0){
            [(id)cardButton setEnabled:!card.unplayable];
            relayout = true;
            NSLog(@"%@ is being removed from the screen", card.contents);
            [UIView animateWithDuration:0.5
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations: ^{
                                 //cardButton.center = CGPointMake(0,0);
                                 cardButton.alpha= 0;
                             }
             
                             completion: ^(BOOL completed){
                                 NSLog(@"Animation Complete");
                             }];
        }
    }
    
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    if(relayout){
        [self relayoutButtons];
    }
}

- (void) relayoutButtons{
    //Overided by subclasses
}


- (IBAction)modeChanged:(UISwitch *)sender {
    self.game.extreme = self.switcher.on;
    [UIView transitionWithView:self.cardContainer duration:1.0 options:UIViewAnimationOptionTransitionFlipFromTop
                    animations:NULL completion:NULL];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         [self relayoutButtons];    
                     }completion:NULL];

    
    NSLog(@"Rotating");
}



@end
