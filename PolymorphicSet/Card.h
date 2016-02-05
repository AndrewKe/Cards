//
//  Card.h
//  Matchismo
//
//  Created by Andrew Ke on 9/23/13.
//  Copyright (c) 2013 Andrew Ke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString * contents;
@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, getter = isUnplayable) BOOL unplayable;
@property (nonatomic) NSAttributedString *label;

-(int)match: (NSArray *)otherCards;
@end
