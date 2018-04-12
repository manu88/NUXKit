//
//  UIButtonContent.m
//  NUXKit
//
//  Created by Manuel Deneu on 11/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#import "UIButtonContent.h"

@implementation UIButtonContent



- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder; // NS_DESIGNATED_INITIALIZE
{
    if( self = [super init])
    {
        self.title = [aDecoder decodeObjectForKey:@"UITitle"];
        return self;
    }
    
    return nil;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    assert(false);
}

@end
