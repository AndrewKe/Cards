//
//  SetCard.h
//  Set
//
//  Created by Andrew Ke on 10/29/13.
//  Copyright (c) 2013 Andrew Ke. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

#define TRIANGLE 1
#define CIRCLE 2
#define SQUARE 3

#define BLANK 0
#define HALF 0.25
#define FULL 1

#define RED 1
#define PURPLE 2
#define GREEN 3

#define ONE 1
#define TWO 2
#define THREE 3



@property (nonatomic) int shape;
@property (nonatomic) double shading;
@property (nonatomic) int color;
@property (nonatomic) int quantity;
@property (nonatomic, strong) NSMutableAttributedString *label;

@end
