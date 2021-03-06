//
//  PlayingCardView.h
//  SuperCard
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardGameViewController.h"

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL enabled;
@property (strong, nonatomic) CardGameViewController *vc;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
