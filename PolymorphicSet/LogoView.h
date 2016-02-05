//
//  LogoView.h
//  PolymorphicSet
//
//  Created by Andrew Ke on 12/27/13.
//  Copyright (c) 2013 Andrew Ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogoView : UIView

@property (nonatomic, strong) NSString* shape;
@property (nonatomic) double shading;
@property (nonatomic, strong) UIColor* color;
@property (nonatomic) CGFloat width;

@end
