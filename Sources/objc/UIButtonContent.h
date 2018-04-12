//
//  UIButtonContent.h
//  NUXKit
//
//  Created by Manuel Deneu on 11/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButtonContent : NSObject< NSCoding>
{
    NSString * _title;
    //UIColor * titleColor;
}

@property (nonatomic, retain) NSString * _Nullable title;
//@property (nonatomic, retain) UIColor *titleColor;

- (nullable instancetype)initWithCoder:(NSCoder *_Nonnull)aDecoder; // NS_DESIGNATED_INITIALIZER
- (void)encodeWithCoder:(NSCoder *_Nonnull)aCoder;

@end
