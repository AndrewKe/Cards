//
//  SetView.m
//  PolymorphicSet
//
//  Created by Andrew Ke on 12/23/13.
//  Copyright (c) 2013 Andrew Ke. All rights reserved.
//

#import "SetView.h"
#import "Card.h"
#import "LogoView.h"
#import "CardGameViewController.h"

@implementation SetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void) awakeFromNib
{
    [self setUp];
}

- (void) setUp{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    
    [self setNeedsDisplay];
    
    
}

- (void) setVc:(UIViewController *)vc{
    _vc = vc;
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tap];
}


- (IBAction)tapped:(id)sender{
    NSLog(@"TAP");
    [self.vc viewTapped:self];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0
#define LOGO_SPACING 10

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)spacing {return LOGO_SPACING * [self cornerScaleFactor];}

- (void)drawRect:(CGRect)rect
{
    for(UIView *subview in [self subviews]){
        [subview removeFromSuperview];
    }
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[self getCurrentColor] setFill];
    UIRectFill(self.bounds);
    
    
    double logoWidth = (self.bounds.size.width - (2+ self.quantity-1)*[self spacing])/self.quantity;
    for(int i = 0; i< self.quantity; i++){
        LogoView *view = [[LogoView alloc] init];
        view.frame = CGRectMake([self spacing]+i*logoWidth+i*[self spacing], [self spacing],logoWidth, self.bounds.size.height- 2* [self spacing]);
        view.shape = self.shape;
        view.color = self.color;
        view.shading = self.shading;
        view.width  = (self.bounds.size.width - 4*[self spacing])/3;
        //view.backgroundColor = [UIColor grayColor];
        [self addSubview:view];
    }
    
}

- (UIColor *)getCurrentColor{
    if(self.selected){
        return [UIColor yellowColor];
    }else{
        return [UIColor whiteColor];
    }
}

- (void) setAttributedTitle: (NSMutableAttributedString *) string forState: (id)state
{

    self.quantity = string.string.length;
    self.shape = [string.string substringWithRange:NSMakeRange(0, 1)];
    
    NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
    self.color = [attributes objectForKey:NSStrokeColorAttributeName];
    UIColor *fillColor = [attributes objectForKey:NSForegroundColorAttributeName];
    self.shading = CGColorGetAlpha(fillColor.CGColor);
    
    //NSLog(@"Title of SetView has changed to %@ with Length: %d, Shape: %@, Shading: %f, and Color %@", string.string, self.quantity, self.shape, self.shading, self.color.description);
    [self setNeedsDisplay];
}



@end
