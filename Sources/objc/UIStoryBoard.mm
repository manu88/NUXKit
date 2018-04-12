//
//  StoryBoardPlugin.m
//  TestAPI
//
//  Created by Manuel Deneu on 31/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#import  "UIStoryBoard.h"
#import "CustomCoder.h"
#include "../StoryBoardParser/include/StoryboardDocument.hpp"
#include "TestStoryBoard-Swift.h"
//#include "TestNoStoryBoard-Swift.h"
#include "XMLDocument.hpp"


@implementation UIStoryboard
{
    //Storyboard::Document* _doc;
    XMLDocument *doc;
    
    XMLNode scenesNode;
    XMLNode initialVCNode;
    
    NSMutableDictionary* _createdInstances;
    NSMutableDictionary* _segueSenders;
    
    std::string initialViewControllerID;
    
    NSMutableDictionary *_viewControllers;
    
}

-(nonnull id) initWithName:(NSString*)name bundle: (NSBundle*) bundle
{
    if ( self = [super init])
    {
        self->doc = new XMLDocument( [ name cStringUsingEncoding:NSUTF8StringEncoding ] );
        
        _createdInstances = [[NSMutableDictionary alloc] init];
        _segueSenders     = [[NSMutableDictionary alloc] init];
        
        _viewControllers = [[NSMutableDictionary alloc] init];
        if (doc->isValid() == false)
        {
            return nil;
        }
        //initialViewControllerID = nil;
        
        
        
        return self;
    }
    return nil;
}

-(BOOL) addInstance: (id) object forKey:(NSString*) key
{
    [_createdInstances setObject:object forKey:key];
    
    return [_createdInstances objectForKey:key] != nil;
}

-(BOOL) registerSegueSender: (id) object destId:(NSString*) destId
{
    [_segueSenders setObject:destId forKey:object];
    
    return [_segueSenders objectForKey:destId] != nil;
}

- (BOOL)prepareDoc
{
    assert(initialViewControllerID.empty());
    
    assert(doc);
    assert(doc->isValid());
    
    
    if( doc->getRoot().getName() != "document")
        return NO;
    
    
    if( doc->getRoot().hasProperty("targetRuntime"))
    {
        //sb.setTargetRuntime( doc.getRoot().getProperty("targetRuntime") );
    }
    
    if( doc->getRoot().hasProperty("initialViewController"))
    {
        initialViewControllerID = doc->getRoot().getProperty("initialViewController");
        
        //sb.setInitialViewControllerID( doc.getRoot().getProperty("initialViewController") );
    }
    
    scenesNode = doc->getRoot().getChildByName("scenes");
    
    if (scenesNode.isValid() == false)
    {
        return NO;
    }
    
    
    for( const auto &scene : scenesNode.getChildren())
    {
        const auto objects = scene.second.getChildByName("objects");
        
        if( objects.isValid() == false)
        {
            return false;
        }
        
        const auto viewControlerNode = objects.getChildByName("viewController");
        
        if( viewControlerNode.isValid() == false)
        {
            return false;
        }
        
        if( viewControlerNode.getProperty("id") == initialViewControllerID)
        {
            initialVCNode = viewControlerNode;
        }
        
        
    }
    
    
    return initialVCNode.isValid();
}



-(void)dealloc
{
    delete doc;
}

- (__kindof UIViewController *_Nullable )instantiateInitialViewController
{
    
    if( initialViewControllerID.empty())
    {
        if( [self prepareDoc] == NO)
        {
            return nil;
        }
    }
    
    assert(initialViewControllerID.empty() == false);
    assert(initialVCNode.isValid());
    
    const auto initialVCName = initialVCNode.getProperty("customClass");
    const auto initialVCModuleName = initialVCNode.getProperty("customModule");
    const auto vdID = initialVCNode.getProperty("id");
    
    assert( initialVCName.empty() == false);
    assert( initialVCModuleName.empty() == false); // Sure?
    
    const auto initialVCFullName = initialVCModuleName + "." + initialVCName;
    
    Class instanceClass = NSClassFromString( [NSString stringWithFormat:@"%s", initialVCFullName.c_str() ] );
    
    if( instanceClass )
    {
        NSCoder* decoder = [[CustomCoder alloc] initWithXMLNode: initialVCNode storyboard:self];
        
        UIViewController * vc =[ [instanceClass alloc] initWithCoder:decoder];
        
        [_viewControllers setObject:vc forKey:[NSString stringWithFormat:@"%s" , vdID.c_str()]];
        
        UIView* view = [decoder decodeTopLevelObjectForKey:@"UIView" error:nil];
        
        const auto connectionsNode = initialVCNode.getChildByName("connections");
        if(connectionsNode.isValid() )
        {
            for( const auto &connecNode : connectionsNode.getChildren())
            {
                //<outlet property="mylabel" destination="XmU-Eo-b7z" id="EVj-Yf-qUO"/>
                const auto propertyName = connecNode.second.getProperty("property");
                const auto destinationID = connecNode.second.getProperty("destination");
                const auto idName = connecNode.second.getProperty("id");

                const NSString* idStr = [NSString stringWithFormat:@"%s" , destinationID.c_str()];
                
                NSObject* propValue = [_createdInstances objectForKey:idStr];

                assert(propValue);
                
                NSString* propertyStr = [NSString stringWithFormat:@"%s" , propertyName.c_str()];
                [vc setValue:propValue forKey:propertyStr];
                
            }
        }
        
        assert(view);
        [vc setView:view];
        
        return vc;
    }

    return nil;
}

- (__kindof UIViewController * _Nullable)getViewControllerWithID:(NSString*) id_
{
    return [_viewControllers objectForKey:id_];
}
@end
