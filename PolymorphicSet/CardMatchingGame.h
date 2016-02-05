//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Andrew Ke on 9/25/13.
//  Copyright (c) 2013 Andrew Ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

//designated initializer
- (id)initWithCardCount: (NSUInteger)cardCount
              usingDeck: (Deck *)deck;

- (void)flipCardAtIndex: (NSUInteger) index;
- (Card *) cardAtIndex: (NSUInteger) index;
- (void) replaceCardAtIndex: (NSUInteger)index withCard: (Card *)card;

@property (nonatomic, readonly) int score;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSAttributedString *attributedInfo;
@property (nonatomic) BOOL extreme;
@property (nonatomic) BOOL useAttributedText;
@end
