//
//  Deck.h
//  Matchismo
//
//  Created by Andrew Ke on 9/23/13.
//  Copyright (c) 2013 Andrew Ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

-(void)addCard: (Card *)card atTop: (BOOL) atTop;
- (Card *)drawRandomCard;

@end
