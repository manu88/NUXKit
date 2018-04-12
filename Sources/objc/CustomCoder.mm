//
//  CustomCoder.m
//  NUXKit
//
//  Created by Manuel Deneu on 09/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#import "CustomCoder.h"
#import "UIButtonContent.h"
#include "SB_Scene.hpp"
#include "XMLDocument.hpp"
//#include "TestStoryBoard-Swift.h"
#include "TestNoStoryboard-Swift.h"

//@class UIButtonContent;


static UIColor* parseColorNode( const XMLNode& node);
static CGRect parseCGRectNode(const XMLNode &node);

@implementation CustomCoder
{
    XMLNode _node;
    
    NSMutableDictionary* keyTranslationsNS_to_XML;
    NSMutableDictionary* classTranslationsXML_to_NS;
    
    
}

- (nonnull id) initWithXMLNode:( const XMLNode& ) node
{
    if( self = [super init ] )
    {
        self->_node = node;
        
        _allowsKeyedCoding = YES;
        //self.allowsKeyedCoding = YES;
        _requiresSecureCoding = YES;
        
        keyTranslationsNS_to_XML = [[NSMutableDictionary alloc] init];
        classTranslationsXML_to_NS = [[NSMutableDictionary alloc] init];
        
        [self populateTranslationKeys];
        [self populateClasseNames];
        return self;
    }
    return nil;
}

-(NSString*) getClassNameFromXMLName:(const std::string&) nodeName
{
    //return [classTranslationsXML_to_NS valueForKey:nodeName];
    
    const NSString* baseClassName = [classTranslationsXML_to_NS valueForKey: [NSString stringWithFormat:@"%s", nodeName.c_str()] ];
    
    if( baseClassName == nil)
    {
        return nil;
    }
    NSString* ret = [NSString stringWithFormat:@"%@.%@", @"TestStoryBoard" ,
                        baseClassName
                   ];
    
    return ret;
}

-(void) populateClasseNames
{
    [classTranslationsXML_to_NS setObject:@"UIView"   forKey:@"view"];
    [classTranslationsXML_to_NS setObject:@"UIButton" forKey:@"button"];
    [classTranslationsXML_to_NS setObject:@"UILabel"  forKey:@"label"];
    
}
-(void) populateTranslationKeys
{
    [keyTranslationsNS_to_XML setObject:@"subviews"         forKey: @"UISubviews"];
    [keyTranslationsNS_to_XML setObject:@"view"             forKey: @"UIView"];
    [keyTranslationsNS_to_XML setObject:@"state"            forKey: @"UIButtonStatefulContent"];
    [keyTranslationsNS_to_XML setObject:@"title"            forKey: @"UITitle"];
    [keyTranslationsNS_to_XML setObject:@"text"             forKey: @"UIText"];
    [keyTranslationsNS_to_XML setObject:@"textColor"        forKey: @"UITextColor"];
    [keyTranslationsNS_to_XML setObject:@"backgroundColor"  forKey: @"UIBackgroundColor"];
    
    [keyTranslationsNS_to_XML setObject:@"rect"             forKey: @"UIBounds"];
    //[keyTranslationsNS_to_XML setObject:@"rect"             forKey: @"UIFrame"];
    
}

-(BOOL) containsValueForKey:(NSString *)key
{
    return [keyTranslationsNS_to_XML objectForKey:key] != nil;
    //return [keyTranslationsNS_to_XML doesContain:key] ;
}

- (nullable id)decodeObjectForKey:(NSString *)key
{

    const NSString* xmlKey = [keyTranslationsNS_to_XML valueForKey: key];
    
    if( xmlKey == nil)
    {
        NSLog(@"[decodeTopLevelObjectForKey] key translation not found for %@" , key);
        return nil;
    }
    if( [key isEqualToString:@"UIButtonStatefulContent"])
    {

        auto getRawStateValueFromName = []( const std::string &name ) -> NSNumber*
        {
            int val = -1;
            
            if( name == "normal" )      val = 0;
            else if( name == "highlighted" ) val = 1;
            else if( name == "disabled" )    val = 2;
            else if( name == "selected" )    val = 4;
            
            assert(val >= 0);
            return [NSNumber numberWithInt:val];
            
        };
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        for( const auto& stateNode : _node.getChildren())
        {
            if( stateNode.first == "state")
            {
                printf("Add a state %s\n" ,stateNode.second.getProperty("key").c_str() );
                CustomCoder* decoder = [[CustomCoder alloc] initWithXMLNode: stateNode.second ] ;
                
                UIButtonContent* ct = [[UIButtonContent alloc] initWithCoder:decoder];
                
                if( ct)
                {
                    const auto stateName = stateNode.second.getProperty("key");
                    [dict setObject:ct forKey:getRawStateValueFromName(stateName)];
                }
            }
        }
        
        return dict;
    }
    
    else if( [key isEqualToString:@"UITitle"])
    {
        const char* rawKey = [xmlKey cStringUsingEncoding: NSUTF8StringEncoding ];
        
        if( _node.hasProperty( rawKey ))
        {
            return [NSString stringWithFormat:@"%s" , _node.getProperty( rawKey ).c_str() ];
        }
        return nil;
    }
    else if( [key isEqualToString:@"UIText"])
    {
        const char* rawKey = [xmlKey cStringUsingEncoding: NSUTF8StringEncoding ];
        
        if( _node.hasProperty( rawKey ))
        {
            return [NSString stringWithFormat:@"%s" , _node.getProperty( rawKey ).c_str() ];
        }
        return nil;
    }
    else if( [key isEqualToString:@"UITextColor"])
    {
        const auto colorNode = _node.getChildByName("color");
        
        if(colorNode.isValid())
        {
            const char* rawKey = [xmlKey cStringUsingEncoding: NSUTF8StringEncoding ];
            if (colorNode.hasProperty("key") && colorNode.getProperty("key") == rawKey )
            {
                return parseColorNode(colorNode);
            }
        }
        return nil;
    }
    else if( [key isEqualToString:@"UIBackgroundColor"])
    {
        const auto colorNode = _node.getChildByName("color");
        
        if(colorNode.isValid())
        {
            const char* rawKey = [xmlKey cStringUsingEncoding: NSUTF8StringEncoding ];
            if (colorNode.hasProperty("key") && colorNode.getProperty("key") == rawKey )
            {
                return parseColorNode(colorNode);
            }
        }
        return nil;
    }
    else
    {
        NSLog(@"CustomCoder.decodeObjectForKey request for key  '%@'  NOT FOUND" , key);
    }
    /*
    if([self containsValueForKey:key ])
    {
        return [super decodeObjectForKey:key];
    }
     */
    return nil;
}

-(nullable id) decodeObjectOfClass:(Class)aClass forKey:(NSString *)key
{
    return nil;
}


- (nullable id)decodeTopLevelObjectForKey:(NSString *)key error:(NSError **)error
{

    const NSString* xmlKey = [keyTranslationsNS_to_XML valueForKey: key];
    
    if( xmlKey == nil)
    {
        //NSLog(@"[decodeTopLevelObjectForKey] key translation not found for %@" , key);
        return nil;
    }
    
    
    
    if( [key isEqualToString:@"UIView"])
    {
        Class instanceClass = NSClassFromString([self getClassNameFromXMLName:"view"  ]);// @"TestStoryBoard.UIView" );
        
        const auto viewNode = _node.getChildByName( [ xmlKey cStringUsingEncoding:NSUTF8StringEncoding ]);
        assert( viewNode.isValid() );
        
        CustomCoder* decoder = [[CustomCoder alloc] initWithXMLNode: viewNode ] ;
        
        return [[instanceClass alloc] initWithCoder: decoder ];
    }
    else if( [key  isEqualToString: @"UISubviews"])
    {
        const auto subViewsNode = _node.getChildByName( [ xmlKey cStringUsingEncoding:NSUTF8StringEncoding ]);
        
        if (subViewsNode.isValid() == false)
        {
            return nil;
        }
        
        
        NSMutableArray* subviews = [[NSMutableArray alloc] init];

        for( const auto& subV : subViewsNode.getChildren())
        {
            Class instanceClass = NSClassFromString([self getClassNameFromXMLName:subV.first ]);// @"TestStoryBoard.UIView" );
            if( instanceClass)
            {
                
                
                CustomCoder* decoder = [[CustomCoder alloc] initWithXMLNode: subV.second] ;
                
                id view =[[instanceClass alloc] initWithCoder: decoder ];
                
                if( view)
                {
                    
                    [subviews addObject:view];
                }
            }
        }// end for
        
        return subviews;
    }
    
    else
    {
        NSLog(@"CustomCoder.decodeTopLevelObjectForKey request for key '%@'" , key);
    }

    return nil;
}

- (nullable id)decodeObjectOfClasses:(nullable NSSet<Class> *)classes forKey:(NSString *)key
{
    //NSLog(@"decodeObjectOfClasses key = '%@' classes : %@" , key , classes.description);

    return nil;
}

-(BOOL) decodeBoolForKey:(NSString *)key
{
    if( [key isEqualToString:@"UIDeepDrawRect"])
        return YES;
    
    return NO;
}

- (NSRect)decodeRectForKey:(NSString *)key
{
    
    const NSString* xmlKey = [keyTranslationsNS_to_XML valueForKey: key];
    
    if( xmlKey == nil)
    {
        return CGRectZero;
    }
    
    if( [key  isEqualToString: @"UIBounds"])
    {
        const char* rawKey = [xmlKey cStringUsingEncoding: NSUTF8StringEncoding ];
        const auto rectNode = _node.getChildByName(rawKey);
        
        if( rectNode.isValid() && rectNode.hasProperty("key") && rectNode.getProperty("key") == "frame" )
        {
            return parseCGRectNode(rectNode);
        }
    }
    
    return CGRectZero;
}


/* **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** */
/* **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** */


static CGRect parseCGRectNode(const XMLNode &node)
{
    //CGRect ret;
    
    if ( node.hasProperty("x") && node.hasProperty("y") && node.hasProperty("width") && node.hasProperty("height"))
    {
        const CGFloat x = std::stof(node.getProperty("x"));
        const CGFloat y = std::stof(node.getProperty("y"));
        const CGFloat w = std::stof(node.getProperty("width"));
        const CGFloat h = std::stof(node.getProperty("height"));
        
        return CGRectMake(x, y, w, h);
    }
    return CGRectNull;
}

static UIColor* parseColorNode( const XMLNode& node)
{
    if( node.hasProperty("red") && node.hasProperty("green") && node.hasProperty("blue"))
    {
        const float r = std::stof(node.getProperty("red"));
        const float g = std::stof(node.getProperty("green"));
        const float b = std::stof(node.getProperty("blue"));
        const float a = std::stof(node.getProperty("alpha"));
        
        UIColor* color = [ [UIColor alloc] initWithRed:r green:g blue:b alpha:a ];
        
        return color;
    }
    
    return nil;
}

@end
