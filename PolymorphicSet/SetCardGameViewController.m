//
//  SetCardGameViewController.m
//  PolymorphicSet
//
//  Created by Andrew Ke on 11/11/13.
//  Copyright (c) 2013 Andrew Ke. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "CardMatchingGame.h"
#import "CardGameViewController.h"
#import "SetView.h"
#import "Grid.h"
#import <math.h>

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (Deck *)getDeck
{
    return [[SetCardDeck alloc] init];
}

- (void) viewDidLoad{
    [super viewDidLoad];
    self.game.extreme = true;
    self.useAttributedText = true;
    
    NSLog(@"Helo");
    
    Grid *g = [[Grid alloc] init];
    g.size = self.cardContainer.bounds.size;
    g.cellAspectRatio = 1.2;
    g.minimumNumberOfCells = 12;
    
    NSLog(@"New Grid with %lu rows and %lu columns. ", (unsigned long)g.rowCount, (unsigned long)g.columnCount);
    int farX = [g frameOfCellAtRow:0 inColumn:g.columnCount-1].origin.x + [g frameOfCellAtRow:0 inColumn:g.columnCount-1].size.width-4;
    int farY = [g frameOfCellAtRow:((int)(g.minimumNumberOfCells/g.columnCount))-1 inColumn:0].origin.y+[g frameOfCellAtRow:g.rowCount-1 inColumn:0].size.height-4;
    int xMove = (self.cardContainer.bounds.size.width-farX)/2;
    int yMove = (self.cardContainer.bounds.size.height-farY)/2;
    NSLog(@"FarY is %d and yMove is %d", farY, yMove);
    self.cardButtons = [[NSArray alloc] init];
    
    for (int i = 0; i<g.rowCount; i++){
        for(int j = 0; j<g.columnCount; j++){
            if((i*g.columnCount+j) < 12){
                SetView *v = [[SetView alloc] init];
                CGRect r  = [g frameOfCellAtRow:i inColumn:j];
                r.size.width = r.size.width - 4;
                r.size.height = r.size.height - 4;
                r.origin = CGPointMake(r.origin.x+xMove, r.origin.y + yMove);
                v.frame = r;
                
                //v.center = [g centerOfCellAtRow:i inColumn:j];
                [self.cardContainer addSubview:v];
                self.cardButtons = [self.cardButtons arrayByAddingObjectsFromArray:@[v]];
            }
        }
    }
    
    
    for(SetView *view in self.cardButtons){
        view.vc = self;
        //view.hidden = true;
    }
    
    self.game = nil;
    
}

- (void) relayoutButtons{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for(SetView* v in self.cardButtons){
        if(!v.alpha <1){
            [temp addObject:v];
            //v.userInteractionEnabled = true;
        }
    }
    NSLog(@"%lu card are being re-arranged", (unsigned long)temp.count);
    

    [self reLayoutButtonsUsingCards:temp];

    
    
}

- (void) reLayoutButtonsUsingCards: (NSArray *) cards{
    
    Grid *g = [[Grid alloc] init];
    g.size = self.cardContainer.bounds.size;
    g.cellAspectRatio = 1.2;
    g.minimumNumberOfCells = cards.count;
    
    NSLog(@"New Grid with %lu rows and %lu columns. ", (unsigned long)g.rowCount, (unsigned long)g.columnCount);
    int farX = [g frameOfCellAtRow:0 inColumn:g.columnCount-1].origin.x + [g frameOfCellAtRow:0 inColumn:g.columnCount-1].size.width-4;
    int farY = [g frameOfCellAtRow:floor(cards.count*1.0/g.columnCount- 0.01) inColumn:0].origin.y+[g frameOfCellAtRow:g.rowCount-1 inColumn:0].size.height-4;
    int xMove = (self.cardContainer.bounds.size.width-farX)/2;
    int yMove = (self.cardContainer.bounds.size.height-farY)/2;
    NSLog(@"FarX is %d and xMove is %d", farX, xMove);
    NSLog(@"FarY is %d and yMove is %d", farX, xMove);
    NSLog(@"Column # is %f",  floor(cards.count*1.0/g.columnCount- 0.01));
    
    for (int i = 0; i<g.rowCount; i++){
        for(int j = 0; j<g.columnCount; j++){
            if((i*g.columnCount+j) < cards.count){
                SetView *v = cards[i*g.columnCount+j];
                CGRect r  = [g frameOfCellAtRow:i inColumn:j];
                r.size.width = r.size.width - 4;
                r.size.height = r.size.height - 4;
                r.origin = CGPointMake(r.origin.x+xMove, r.origin.y+yMove);
                v.frame = r;
                //v.backgroundColor = [UIColor greenColor];
                //v.center = [g centerOfCellAtRow:i inColumn:j];
                //[self.cardContainer addSubview:v];
            }
        }
    }
}
- (IBAction)getMoreCards {
    NSLog(@"Getting More Cards...");
    NSMutableArray *goodCards = [[NSMutableArray alloc] init];
    NSMutableArray *badCards = [[NSMutableArray alloc] init];
    for(SetView* v in self.cardButtons){
        if(!v.alpha <1){
            [goodCards addObject:v];
        }else{
            [badCards addObject:v];
        }
    }
    NSMutableArray *newCards = [[NSMutableArray alloc] init];
    if(badCards.count >=3){
        newCards = [[badCards subarrayWithRange:NSMakeRange(0, 3)] mutableCopy];
    }else{
        for (int i =0; i<3; i++){
            SetView *v = [[SetView alloc] init];
            self.cardButtons = [self.cardButtons arrayByAddingObject:v];
            v.vc = self;
            [self.cardContainer addSubview:v];
            [newCards addObject:v];
        }
    }
    goodCards = [goodCards arrayByAddingObjectsFromArray:newCards];
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
            [self reLayoutButtonsUsingCards:goodCards];
                     }completion:NULL];
    NSMutableArray *formerPositions = [[NSMutableArray alloc] init];
    for (SetView *v in newCards){
        [formerPositions addObject:[NSValue valueWithCGPoint: v.center]];
        v.center = CGPointMake(-50, -50);
        Card *newCard = [[[SetCardDeck alloc] init] drawRandomCard];
        [self.game replaceCardAtIndex:[self.cardButtons indexOfObject:v] withCard:newCard];
    }
    [self updateUI];
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         for(SetView *v in newCards){
                             v.alpha = 1;
                             NSValue *d = [formerPositions objectAtIndex:[newCards indexOfObject:v]];
                             v.center = d.CGPointValue;
                         }
                     }completion:NULL];
        

    
}


@end
