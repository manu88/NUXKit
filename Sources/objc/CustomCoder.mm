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

#import "UIStoryBoard.h"
#include "TestStoryBoard-Swift.h"
//#include "TestNoStoryboard-Swift.h"

//@class UIButtonContent;


static UIColor* parseColorNode( const XMLNode& node);
static CGRect parseCGRectNode(const XMLNode &node);

@implementation CustomCoder
{
    UIStoryboard* _storyboard;
    XMLNode _node;
    
    NSMutableDictionary* keyTranslationsNS_to_XML;
    NSMutableDictionary* classTranslationsXML_to_NS;
    
    
}

- (nonnull id) initWithXMLNode:( const XMLNode& ) node storyboard:(UIStoryboard*_Nonnull) storyboard;
{
    if( self = [super init ] )
    {
        self->_node = node;
        self->_storyboard = storyboard;
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
    [classTranslationsXML_to_NS setObject:@"UISlider" forKey:@"slider"];
    [classTranslationsXML_to_NS setObject:@"UITextField" forKey:@"textField"];
    
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
    [keyTranslationsNS_to_XML setObject:@"placeholder"             forKey: @"UIPlaceholder"];
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
                CustomCoder* decoder = [[CustomCoder alloc] initWithXMLNode: stateNode.second storyboard:_storyboard ] ;
                
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
    
    else if( [key isEqualToString:@"UIPlaceholder"])
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
        return nil;
    }
    
    
    
    if( [key isEqualToString:@"UIView"])
    {
        Class instanceClass = NSClassFromString([self getClassNameFromXMLName:"view"  ]);// @"TestStoryBoard.UIView" );
        
        const auto viewNode = _node.getChildByName( [ xmlKey cStringUsingEncoding:NSUTF8StringEncoding ]);
        assert( viewNode.isValid() );
        
        CustomCoder* decoder = [[CustomCoder alloc] initWithXMLNode: viewNode storyboard:_storyboard] ;
        
        id view = [[instanceClass alloc] initWithCoder: decoder ];
        [_storyboard addInstance:view forKey:[NSString stringWithFormat:@"%s" , viewNode.getProperty("id").c_str() ]];
        return view;
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
                CustomCoder* decoder = [[CustomCoder alloc] initWithXMLNode: subV.second storyboard:_storyboard ] ;
                
                id view =[[instanceClass alloc] initWithCoder: decoder ];
                
                [_storyboard addInstance:view forKey:[NSString stringWithFormat:@"%s" , subV.second.getProperty("id").c_str() ]];
                
                if ([view isKindOfClass:[UIControl class] ])
                {
                    const auto connectionListNode = subV.second.getChildByName("connections");
                    
                    
                    if( connectionListNode.isValid())
                    {
                        for( const auto &connectNode : connectionListNode.getChildren() )
                        {
                            if (connectNode.first == "action")
                            {
                                const auto selectorName = connectNode.second.getProperty("selector");
                                const auto destName = connectNode.second.getProperty("destination");
                                const auto eventTypeName = connectNode.second.getProperty("eventType");

                                
                                UIViewController* attachedViewController = [_storyboard getViewControllerWithID:
                                                                            [NSString stringWithFormat:@"%s" , destName.c_str()]
                                                                            ];
                                
                                if( attachedViewController)
                                {
                                    SEL action = NSSelectorFromString([NSString stringWithFormat:@"%s" , selectorName.c_str()]);

                                    auto controlEventStrToVal = []( const std::string &str) -> unsigned int
                                    {
                                             if( str == "touchDown")                return 1 << 0;
                                        else if( str == "touchDownRepeat")          return 1 << 1;
                                        else if( str == "touchDragInside")          return 1 << 2;
                                        else if( str == "touchDragOutside")         return 1 << 3;
                                        else if( str == "touchDragEnter")           return 1 << 4;
                                        else if( str == "touchDragExit")            return 1 << 5;
                                        else if( str == "touchUpInside")            return 1 << 6;
                                        else if( str == "touchUpOutside")           return 1 << 7;
                                        else if( str == "touchCancel")              return 1 << 8;
                                        else if( str == "valueChanged")             return 1 << 12;
                                        else if( str == "primaryActionTriggered")   return 1 << 13;
                                        
                                        else if( str == "editingDidBegin")       return 1 << 16;
                                        else if( str == "editingChanged")        return 1 << 17;
                                        else if( str == "editingDidEnd")         return 1 << 18;
                                        else if( str == "editingDidEndOnExit")   return 1 << 19;
                                        
                                        else if( str == "allTouchEvents")       return 0x00000FFF;
                                        else if( str == "allEditingEvents")     return 0x000F0000;
                                        else if( str == "allEditingEvents")     return 0x000F0000;
                                        
                                        /*
                                        public static var allEditingEvents: UIControlEvents     { get {return UIControlEvents(rawValue: 0x000F0000 ) } }
                                        
                                        public static var applicationReserved: UIControlEvents  { get {return UIControlEvents(rawValue: 0x0F000000 ) } }  application use
                                        
                                        public static var systemReserved: UIControlEvents       { get {return UIControlEvents(rawValue: 0xF0000000 ) } }  internal framework use
                                        
                                        public static var allEvents: UIControlEvents            { get {return UIControlEvents(rawValue: 0xFFFFFFFF ) } }
                                        */
                                        
                                        
                                        
                                        assert(false);
                                        
                                        return -1;
                                    };
                                    
                                    [(UIControl*) view addTarget:attachedViewController action:action for:controlEventStrToVal(eventTypeName)];
                                } // END if( attachedViewController)
                            
                            
                            } // END if (connectNode.first == "action")
                            else if( connectNode.first == "segue")
                            {
                                const auto destName = connectNode.second.getProperty("destination");
                                const auto kindName = connectNode.second.getProperty("kind");
                                const auto segueIdentifier = connectNode.second.getProperty("identifier");
                                const auto segueID = connectNode.second.getProperty("id");
                                
                                NSLog(@" segue id %s kind %s to %s" , segueIdentifier.c_str() , kindName.c_str() , destName.c_str() );
                                
                                UISegue* segue = [[UISegue alloc] initWithIdentifier:[NSString stringWithFormat:@"%s" , segueIdentifier.c_str()]
                                                                  destinationID:[NSString stringWithFormat:@"%s" , destName.c_str()]
                                                                  kind:[NSString stringWithFormat:@"%s" , kindName.c_str()]
                                                                 sender:view
                                                  ];
                                
                                [_storyboard registerSegueSender:view segue: segue/*[NSString stringWithFormat:@"%s" , segueID.c_str()]*/ ];

                                
                                [(UIControl*) view addTarget:[UIApplication shared] /*_storyboard*/
                                                   action:NSSelectorFromString(@"segueDestinationWithSender:")
                                                   for:1 << 6]; // This is a touchup inside
                            }
                            
                        } // END for( const auto &connectNode
                    }
                }
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
    return nil;
}

-(BOOL) decodeBoolForKey:(NSString *)key
{
    if( [key isEqualToString:@"UIDeepDrawRect"])
        return YES;
    
    if( [key isEqualToString:@"UIHidden"] &&  _node.hasProperty("hidden"))
        return _node.getProperty("hidden") == "YES";
    
    if( [key isEqualToString:@"UIDisabled"])
    {
        if( _node.hasProperty("enabled"))
            return _node.getProperty("enabled") == "NO";
        
        return NO;
    }
    
    if( [key isEqualToString:@"UIHighlighted"])
    {
        if( _node.hasProperty("highlighted"))
            return _node.getProperty("highlighted") == "YES";
        
        return YES;
    }
        
                         
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
