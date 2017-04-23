//
//  UITextField+isEmpty.m
//  MultiTaskTest
//
//  Created by Maksim Dehanov on 21.04.17.
//  Copyright © 2017 Maksim Dehanov. All rights reserved.
//

#import "UITextField+isEmpty.h"

@implementation UITextField (isEmpty)

-(BOOL)isEmpty {
    if ([self.text isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

@end
