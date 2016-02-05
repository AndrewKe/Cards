//
//  PlayingCard.m
//  Matchismo
//
//  Created by Andrew Ke on 9/24/13.
//  Copyright (c) 2013 Andrew Ke. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int) match:(NSArray *)otherCards
{
    int score = 0;
    
    if(otherCards.count == 1){
        PlayingCard *otherCard = [otherCards lastObject];
        if([otherCard.suit isEqualToString:self.suit]){
            score = 1;
        }else if (otherCard.rank == self.rank){
            score = 4;
        }
    }else if(otherCards.count ==2){
        if([self.suit isEqualToString:[otherCards[0]suit]] && [self.suit isEqualToString:[otherCards[1] suit]]){
            score = 8;
        }
        else if(self.rank == [otherCards[0]rank] && self.rank == [otherCards[1]rank]){
            score = 40;
        }else if(self.rank == [otherCards[0]rank] |  self.rank == [otherCards[1]rank] | [otherCards[0]rank] == [otherCards[1]rank]){
            score = 10;
        }else if([self.suit isEqualToString:[otherCards[0]suit]] | [self.suit isEqualToString:[otherCards[1] suit]] | [[otherCards[0] suit] isEqualToString:[otherCards[1] suit]]){
            score = 6;
        }
        
    }
    return score;
}
- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return @[@"♠",@"♣",@"♥",@"♦"];
}

- (void) setSuit:(NSString *)suit
{
    if([[PlayingCard validSuits] containsObject:suit]){
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger) maxRank
{
    return [self rankStrings].count-1;
}

- (void) setRank:(NSUInteger)rank
{
    if(rank <= [PlayingCard maxRank]){
        _rank = rank;
    }
}

@end
