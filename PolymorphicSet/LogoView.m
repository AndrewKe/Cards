//
//  LogoView.m
//  PolymorphicSet
//
//  Created by Andrew Ke on 12/27/13.
//  Copyright (c) 2013 Andrew Ke. All rights reserved.
//

#import "LogoView.h"
#include <math.h>

@implementation LogoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void) awakeFromNib{
    [self setUp];
}

- (void) setUp{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if([self.shape isEqualToString:@"■"]){
        [self drawDiamond];
    }if([self.shape isEqualToString:@"★"]){
        [self drawBumper];
    }
    if([self.shape isEqualToString:@"▲"])
    [self drawCurve];

}

- (void) drawDiamond{
    UIBezierPath *path = [[UIBezierPath alloc]init];
    int height = self.bounds.size.height;
    int width = self.bounds.size.width;
    [path moveToPoint:CGPointMake(width/2, 0)];
    [path addLineToPoint:CGPointMake(width/2+self.width/2-1, height/2)];
    [path addLineToPoint:CGPointMake(width/2, height)];
    [path addLineToPoint:CGPointMake(width/2-self.width/2+1, height/2)];
    [path closePath];
    [self.color setStroke];
    [[UIColor clearColor] setFill];
    [path fill];
    [path stroke];
    [path addClip];
    [self addShading: path];
    

}

- (void) drawBumper{
    int height = self.bounds.size.height;
    int width = self.bounds.size.width;
    UIBezierPath *connector = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(width/2-self.width/2+2, 1, self.width-2, height-2)];
    [[UIColor clearColor] setFill];
    [self.color setStroke];
    [connector stroke];
    [connector fill];
    [connector addClip];
    
    [self addShading: connector];
    
}

- (void) addShading: (UIBezierPath*) path{
    if(self.shading == 0.25){
        for(int i = 1; i<10; i++){
            int distance = self.bounds.size.height/9;
            UIBezierPath *line = [[UIBezierPath alloc] init];
            [line moveToPoint: CGPointMake(0, i*distance)];
            [line addLineToPoint:CGPointMake(self.bounds.size.width, i*distance)];
            line.lineWidth = 0.4;
            [line stroke];
            [line fill];
        }
    }else if (self.shading == 1.0){
        [self.color setFill];
        [path fill];
    }
}

- (void) drawCurve{
    int height = self.bounds.size.height;
    int width = self.bounds.size.width;
    [self.color setStroke];
    [[UIColor clearColor] setFill];
    UIBezierPath *c = [[UIBezierPath alloc] init];
    [c moveToPoint:CGPointMake(width/2-self.width/2, 1)];
    [c addCurveToPoint:CGPointMake(width/2,height-1) controlPoint1:CGPointMake(width/2, 0) controlPoint2:CGPointMake(width/2-self.width/2, height)];
    [c addLineToPoint:CGPointMake(width/2+ self.width/2, height-1)];
    [c addCurveToPoint:CGPointMake(width/2, 1) controlPoint1: CGPointMake(width/2, height)controlPoint2:CGPointMake(width/2 + self.width/2,0)];
    [c closePath];
    [c stroke];
    [c fill];
    [c addClip];
    [self addShading:c];

    
}
- (void) setShading:(double)shading{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void) setColor:(UIColor *)color{
    _color = color;
    [self setNeedsDisplay];
}

- (void) setShape:(NSString *)shape{
    _shape = shape;
    [self setNeedsDisplay];
}

- (void) setWidth:(CGFloat)width{
    _width = width;
    [self setNeedsDisplay];
}
@end
