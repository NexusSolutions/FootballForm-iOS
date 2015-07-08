//
//  PushNoAnimation.m
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import "PushNoAnimation.h"

@implementation PushNoAnimation

-(void)perform {
    
     [[[self sourceViewController] navigationController] pushViewController:[self   destinationViewController] animated:NO];
}


@end
