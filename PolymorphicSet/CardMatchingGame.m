//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Andrew Ke on 9/25/13.
//  Copyright (c) 2013 Andrew Ke. All rights reserved.
//

#import "CardMatchingGame.h"
#import "SetCard.h"
#import "SetCardDeck.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) int score;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc]init];
    return _cards;
}

- (NSString *) info
{
    if(!_info) _info = @"Welcome!";
    return _info;
}

- (NSAttributedString *) attributedInfo{
    if(!_attributedInfo) _attributedInfo = [[NSAttributedString alloc]initWithString:@"Welcome To Set"];
    NSLog(_attributedInfo.string);
    return _attributedInfo;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if(self){
        for (int i =0; i<count; i++){
            Card *card = [deck drawRandomCard];
            if(!card){
                self = nil;
            }else{
                self.cards[i] = card;
            }
        }
    }

    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index<self.cards.count) ? self.cards[index] : nil;
}

- (void) replaceCardAtIndex: (NSUInteger)index withCard: (Card *)card{
    self.cards[index] = card;
}

#define FLIP_COST 1
#define MISMATCH_PENALTY 1
#define MATCH_BONUS 6

- (void) flipCardAtIndex:(NSUInteger)index
{
    if(!self.extreme){
        [self regularFlipAtIndex:index];
    }else{
        [self extremeFlipAtIndex:index];
    }
}

- (void) regularFlipAtIndex: (NSUInteger) index{
    Card *card = [self cardAtIndex:index];
    
    if(!card.unplayable){
        card.faceUp = !card.isFaceUp;
        if(card.isFaceUp){
            self.info = [NSString stringWithFormat:@"Fliped %@", card.contents];
            for(Card *otherCard in self.cards){
                if(otherCard.isFaceUp && !otherCard.unplayable && otherCard != card){
                    int matchScore = [card match:@[otherCard]];
                    if(matchScore){
                        self.info = [NSString stringWithFormat:@"Matched %@ with %@", card.contents, otherCard.contents];
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                    }else{
                        self.info = @"Mismatch ☹";
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                    }
                }
            }
            self.score -= FLIP_COST;
        }
        //card.faceUp = !card.isFaceUp;
        
    }
}

- (void) extremeFlipAtIndex: (NSUInteger) index{
    Card *card = [self cardAtIndex:index];
    if(!card.unplayable){
        card.faceUp = !card.isFaceUp;
        if(card.isFaceUp){
            self.info = [NSString stringWithFormat:@"Fliped %@", card.contents];
            if(self.useAttributedText){
                card.faceUp = !card.faceUp;
                NSLog(@"Changing");
                NSMutableAttributedString *temp = [[[NSAttributedString alloc]initWithString:@"Flipped "] mutableCopy];
                [temp appendAttributedString:[card.label mutableCopy]];
                self.attributedInfo = temp;
                card.faceUp = !card.faceUp;
            }
            Card *card2 = nil;
            Card *card3 = nil;
            for(Card *otherCard in self.cards){
                if(otherCard.isFaceUp && !otherCard.unplayable && otherCard!= card){
                    if(!card2) card2 = otherCard;
                    else if(!card3) card3 = otherCard;
                }
            }
            if(card2 && card3){
                NSLog(@"MatchTime");
                int matchScore = [card match:@[card2, card3]];
                self.score = matchScore * MATCH_BONUS + self.score;
                if(matchScore){
                    self.info = [NSString stringWithFormat:@"Matched %@ , %@, and %@", card.contents, card2.contents, card3.contents];
                    if(self.useAttributedText){
                        card.faceUp = !card.faceUp;
                        card2.faceUp = !card2.faceUp;
                        card3.faceUp = !card3.faceUp;
                        NSMutableAttributedString *temp = [[NSMutableAttributedString alloc] init];
                        [temp appendAttributedString:[[NSAttributedString alloc] initWithString:@"Matched "]];
                        [temp appendAttributedString:card.label];
                        [temp appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
                        [temp appendAttributedString:card2.label];
                        [temp appendAttributedString:[[NSAttributedString alloc] initWithString:@", and "]];
                        [temp appendAttributedString:card3.label];
                        self.attributedInfo = temp;
                    }
                    card.unplayable = YES;
                    card2.unplayable = YES;
                    card3.unplayable = YES;
                }else{
                    self.info = @"Mismatch ☹";
                    if(self.useAttributedText){
                        NSMutableAttributedString *temp = [self.attributedInfo mutableCopy];
                        [temp appendAttributedString:[[NSAttributedString alloc] initWithString:@" (Mismatch)"]];
                        self.attributedInfo = temp;
                    }
                    card2.faceUp = NO;
                    card3.faceUp = NO;
                    self.score = self.score - MISMATCH_PENALTY;
                }
            }
            self.score -= FLIP_COST;

        }
        
    }

    
}
@end
