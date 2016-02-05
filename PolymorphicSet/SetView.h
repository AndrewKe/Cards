//
//  SetView.h
//  PolymorphicSet
//
//  Created by Andrew Ke on 12/23/13.
//  Copyright (c) 2013 Andrew Ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardGameViewController.h"

@interface SetView : UIView
@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL enabled;

@property (nonatomic) NSString* shape;
@property (nonatomic) double shading;
@property (nonatomic) UIColor* color;
@property (nonatomic) int quantity;
@property (strong, nonatomic) CardGameViewController *vc;

- (void) setAttributedTitle: (NSAttributedString *)string forState: (id)state;

@end
