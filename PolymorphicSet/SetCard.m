//
//  SetCard.m
//  Set
//
//  Created by Andrew Ke on 10/29/13.
//  Copyright (c) 2013 Andrew Ke. All rights reserved.
//

#import "SetCard.h"
#import "Card.h"


@implementation SetCard

@synthesize shape = _shape;
@synthesize quantity = _quantity;
@synthesize color = _color;
@synthesize faceUp = _faceUp;


- (int) match:(NSArray *)otherCards{
    if(otherCards.count != 2){
        return 0;
    }
    int score = 0;
    SetCard *c1 = otherCards[0];
    SetCard *c2 = otherCards[1];
    //NSLog(@"Color a:%d b:%d c:%d",c1.color, c2.color, self.color);
    if(((c1.color == c2.color) && (c2.color == self.color)) || (c1.color != c2.color && c2.color != self.color && self.color!= c1.color)){
        //NSLog(@"Color: MATCH!");
        score++;
    }
    if(((c1.shape == c2.shape) && (c2.shape == self.shape))|| (c1.shape!= c2.shape && c2.shape != self.shape && self.shape!= c1.shape)){
        //NSLog(@"Shape: MATCH!");
        score++;
    }
    if(((c1.shading == c2.shading) && (c2.shading == self.shading))|| (c1.shading!= c2.shading && c2.shading != self.shading && self.shading!= c1.shading)){
        //NSLog(@"Shading: MATCH!");
        score++;
    }
    if(((c1.quantity == c2.quantity) && (c2.quantity == self.quantity))|| (c1.quantity!= c2.quantity && c2.quantity != self.quantity && self.quantity!= c1.quantity)){
        //NSLog(@"Quantity: MATCH!");
        score++;
    }
    if(score==4){
        return 5;
    }else{
        return 0;
    }
    
        
}
- (void) setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    if(_faceUp){
    //[self.label addAttributes:@{NSBackgroundColorAttributeName:[UIColor colorWithRed:0.95 green:0.95 blue:0.5 alpha:1]} range: NSMakeRange(0, self.label.string.length)];
    }else{
        //[self.label addAttributes:@{NSBackgroundColorAttributeName:[UIColor whiteColor]} range: NSMakeRange(0, self.label.string.length)];
        
    }
    
}
- (void) setColor:(int)color{
    _color = color;
    [self updateAttributes];
}


- (int) color
{
    if(!_color) _color = PURPLE;
    return _color;
}

- (void) setShading:(double)shading{
    _shading = shading;
    [self updateAttributes];
}

- (UIColor *) colorAsUIColorWithShading{
    if(self.color == RED) return [UIColor colorWithRed:1 green:0 blue:0 alpha: self.shading];
    if(self.color == PURPLE) return [UIColor colorWithRed:0.75 green:0 blue:0.75 alpha: self.shading];;
    if(self.color == GREEN) return [UIColor colorWithRed:0 green:1 blue:0 alpha: self.shading];;
    return nil;
}

- (UIColor *) colorAsUIColor{
    if(self.color == RED) return [UIColor colorWithRed:1 green:0 blue:0 alpha: 1.0];
    if(self.color == PURPLE) return [UIColor colorWithRed:0.75 green:0 blue:0.75 alpha: 1.00];;
    if(self.color == GREEN) return [UIColor colorWithRed:0 green:1 blue:0 alpha: 1.0];;
    return nil;
    
}

- (void) updateAttributes{
    [self.label addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize: 17] } range:NSMakeRange(0, self.label.string.length)];
    [self.label addAttributes:@{NSForegroundColorAttributeName: [self colorAsUIColorWithShading]} range: NSMakeRange(0, self.label.string.length)];
    [self.label addAttributes:@{NSStrokeWidthAttributeName: @-5.0} range: NSMakeRange(0, self.label.string.length)];
    [self.label addAttributes:@{NSStrokeColorAttributeName: [self colorAsUIColor]} range: NSMakeRange(0, self.label.string.length)];
    
    self.contents = self.label.string;
}

- (void) setQuantity:(int)quantity
{
    _quantity = quantity;
    [self updateText];
    
}
- (NSString *) shapeAsString
{

    if(self.shape == TRIANGLE) return @"▲";
    if(self.shape == SQUARE) return @"■";
    if(self.shape == CIRCLE) return @"★";
    return nil;
}

- (int) shape
{
    if(!_shape) _shape = TRIANGLE;
    return _shape;
}
- (void)setShape:(int)shape
{
    _shape = shape;
    [self updateText];
}

- (void)updateText
{
    self.label = [[NSMutableAttributedString alloc] initWithString:[self multiplyString:[self shapeAsString] withNumber: self.quantity]];
}

-(NSString *) multiplyString:(NSString *)str withNumber: (int)number
{
    NSString *c = [str copy];
    for(int i =1; i<number; i++){
        c = [c stringByAppendingString:str];
    }
    return c;
}





@end
