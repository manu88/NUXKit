//
//  TestCoder.m
//  TestStoryBoard
//
//  Created by Manuel Deneu on 11/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#import "TestCoder.h"


@implementation TestCoder
{
    NSCoder* coder;
    NSString* name;
}


-(nonnull id) init:(NSString *) name coder:(NSCoder*) coder
{
    if( self = [super init])
    {
        self->coder = coder;
        self->name = name;
        _allowsKeyedCoding = YES;

        return self;
    }
    return nil;
}


- (nullable id)decodeObjectOfClass:(Class)aClass forKey:(NSString *)key
{
    
    
    id ret = [coder decodeObjectOfClass:aClass forKey:key];
    
    
    NSLog(@"%@ decodeObjectOfClass %@ key : %@ -> %@" , name , NSStringFromClass(aClass), key , ((NSObject*)ret).description );
    return ret;
}

-(id)decodeObjectOfClasses:(NSSet<Class> *)classes forKey:(NSString *)key
{
    
    
    NSObject* ret =  [coder decodeObjectOfClasses:classes forKey:key];
    
    NSLog(@"%@ decodeObjectOfClasses %@ classes : %@ -> %@ " , name , key , classes.description , ((NSObject*)ret).description );
    //NSLog(@"%@ decodeObjectOfClass %@ key : %@ -> %@" , name , NSStringFromClass(aClass), key , ((NSObject*)ret).description );
    //NSLog(@" returned object : %@" , ret.description);
    
    return ret;
}

-(BOOL) containsValueForKey:(NSString *)key
{
    /*
    if( [key isEqualToString:@"UIFrame"])
        return YES;
    */
    
    BOOL ret = [coder containsValueForKey:key];
    
    NSLog(@"%@ containsValueForKey %@ : %s" , name , key , ret? "YES" : "NO");
    return ret;
}

-(BOOL) decodeBoolForKey:(NSString *)key
{
    
    
    BOOL ret = [coder decodeBoolForKey:key];
    
    NSLog(@"%@ decodeBoolForKey %@ -> %s" , name , key , ret? "YES" : "NO" );
    return ret;
}

-(id) decodeObjectForKey:(NSString *)key
{
    
    
    
    id ret = [coder decodeObjectForKey:key];
    
    
    if( [ret isKindOfClass:NSClassFromString(@"NSDictionary")])
    {
        //UIButtonStatefulContent
    }
    
    if( [key isEqualToString:@"_UITouchedSelectors"])
    {
        
    }
    
    NSLog(@"%@ decodeObjectForKey %@ -> %@" , name , key , ((NSObject*) ret).description);
    return ret;
}


- (CGRect)decodeRectForKey:(NSString *_Nonnull)key
{
    return CGRectNull;
}

-(int64_t) decodeInt64ForKey:(NSString *)key
{
    
    
    int64_t ret = [coder decodeInt64ForKey:key];
    
    NSLog(@"%@ decodeInt64ForKey %@ -> %lli" , name , key , ret);
    return ret;
}

-(CGRect) decodeCGRectForKey:(NSString *)key
{
    
    CGRect ret = [coder decodeCGRectForKey:key];
    NSLog(@"%@ decodeCGRectForKey %@ -> {%f %f %f %f }" , name , key , ret.origin.x , ret.origin.y, ret.size.width , ret.size.height );
    return ret;
}
-(CGPoint)decodeCGPointForKey:(NSString *)key
{
    CGPoint ret = [coder decodeCGPointForKey:key];
    NSLog(@"%@ decodeCGPointForKey %@ -> {%f %f }" , name , key , ret.x , ret.y);
    return ret;
}

-(CGSize) decodeCGSizeForKey:(NSString *)key
{
    CGSize ret = [coder decodeCGSizeForKey:key];
    NSLog(@"%@ decodeCGPointForKey %@ -> {%f %f }" , name , key ,  ret.width , ret.height );
    return ret;
}

-(float ) decodeFloatForKey:(NSString *)key
{
    float ret = [coder decodeFloatForKey:key];
    
    NSLog(@"%@ decodeInt64ForKey %@ -> %f" , name , key , ret);
    
    return ret;
}

-(id) decodeTopLevelObjectForKey:(NSString *)key error:(NSError * _Nullable __autoreleasing *)error
{
    NSLog(@"decodeTopLevelObjectForKey %@" , key);
    
    return [coder decodeTopLevelObjectForKey:key error:error];
}

@end
