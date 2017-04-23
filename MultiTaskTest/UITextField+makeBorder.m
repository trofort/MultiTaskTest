//
//  UITextField+makeBorder.m
//  MultiTaskTest
//
//  Created by Maksim Dehanov on 22.04.17.
//  Copyright © 2017 Maksim Dehanov. All rights reserved.
//

#import "UITextField+makeBorder.h"
#import "UIColor+MainColor.h"

@implementation UITextField (makeBorder)

-(void)makeBorder {
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor mainColor].CGColor;
    self.layer.cornerRadius = 5;
}

@end
