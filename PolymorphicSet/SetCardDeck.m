//
//  SetCardDeck.m
//  Set
//
//  Created by Andrew Ke on 11/6/13.
//  Copyright (c) 2013 Andrew Ke. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id) init
{
    self = [super init];
    
    if(self){
        for(NSString *shape in @[@1,@2,@3]){
            for(NSString *quantity in @[@1, @2, @3]){
                for(NSString *color in @[@1, @2, @3]){
                    for(NSString *shading in @[@0, @0.25, @1]){
                        SetCard *card = [[SetCard alloc] init];
                        card.quantity = quantity.description.doubleValue;
                        card.shape = shape.description.doubleValue;
                        card.color = color.description.doubleValue;
                        card.shading = shading.description.doubleValue;
                        [self addCard:card atTop:YES];                    }
                }
            }
        }
        
    }
    return self;
}


@end
