//
//  PlayingCardGameViewController.m
//  PolymorphicSet
//
//  Created by Andrew Ke on 11/11/13.
//  Copyright (c) 2013 Andrew Ke. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "Grid.h"
#import "PlayingCardView.h"
#import <math.h>

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)getDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (void) viewDidLoad{

    
    NSLog(@"Helo");
    
    Grid *g = [[Grid alloc] init];
    g.size = self.cardContainer.bounds.size;
    g.cellAspectRatio = 0.75;
    g.minimumNumberOfCells = 16;
    
    NSLog(@"New Grid with %lu rows and %lu columns. ", (unsigned long)g.rowCount, (unsigned long)g.columnCount);
    int farX = [g frameOfCellAtRow:0 inColumn:g.columnCount-1].origin.x + [g frameOfCellAtRow:0 inColumn:g.columnCount-1].size.width-4;
    int farY = [g frameOfCellAtRow:3 inColumn:0].origin.y+[g frameOfCellAtRow:g.rowCount-1 inColumn:0].size.height-4;
    int xMove = (self.cardContainer.bounds.size.width-farX)/2;
    int yMove = (self.cardContainer.bounds.size.height-farY)/2;
    NSLog(@"FarY is %d and yMove is %d", farY, yMove);
    self.cardButtons = [[NSArray alloc] init];
    
    for (int i = 0; i<g.rowCount; i++){
        for(int j = 0; j<g.columnCount; j++){
            if((i*g.columnCount+j) < 16){
                PlayingCardView *v = [[PlayingCardView alloc] init];
                v.suit = @"♣";
                v.rank = 5;
                v.vc = self;
                //v.faceUp = true;
                CGRect r  = [g frameOfCellAtRow:i inColumn:j];
                r.size.width = r.size.width - 4;
                r.size.height = r.size.height - 4;
                r.origin = CGPointMake(r.origin.x+xMove, r.origin.y + yMove);
                v.frame = r;
                //v.backgroundColor = [UIColor whiteColor];
                //v.center = [g centerOfCellAtRow:i inColumn:j];
                [self.cardContainer addSubview:v];
                self.cardButtons = [self.cardButtons arrayByAddingObjectsFromArray:@[v]];
            }
        }
    }
    
    
    self.game = nil;
    
}

- (void) relayoutButtons{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for(PlayingCardView* v in self.cardButtons){
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
    g.cellAspectRatio = 0.75;
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
                PlayingCardView *v = cards[i*g.columnCount+j];
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



@end
