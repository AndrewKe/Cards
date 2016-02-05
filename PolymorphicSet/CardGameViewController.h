//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Andrew Ke on 9/23/13.
//  Copyright (c) 2013 Andrew Ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

- (Deck *)getDeck; //
- (void) viewTapped: (UIView *) view;
- (void)updateUI;

@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) BOOL useAttributedText;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *cardButtons;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UIView *cardContainer;


@end
