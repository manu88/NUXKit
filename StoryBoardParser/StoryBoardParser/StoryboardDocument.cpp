//
//  StoryboardDocument.cpp
//  StoryBoardParser
//
//  Created by Manuel Deneu on 30/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#include <assert.h>
#include "StoryboardDocument.hpp"
#include "XMLDocument.hpp"
#include "SB_Scene.hpp"

static bool traverseFile( Storyboard::Document &sb , const XMLDocument&doc);
static bool traverseScene( Storyboard::Scene &sc , const XMLNode &scenes);

static bool ParseFile( Storyboard::Document& sb, const std::string &file)
{
    XMLDocument doc(file);
    
    if( doc.isValid() == false)
        return false;

    return traverseFile(sb, doc);
    
}

static bool traverseFile( Storyboard::Document &sb , const XMLDocument&doc)
{
    assert(doc.isValid());
    
    
    if( doc.getRoot().getName() != "document")
        return false;
    
    
    if( doc.getRoot().hasProperty("targetRuntime"))
    {
        sb.setTargetRuntime( doc.getRoot().getProperty("targetRuntime") );
    }
    
    if( doc.getRoot().hasProperty("initialViewController"))
    {
        sb.setInitialViewControllerID( doc.getRoot().getProperty("initialViewController") );
    }
    
    if( doc.getRoot().hasProperty("type"))
    {
        sb.setType( doc.getRoot().getProperty("type") );
        
    }
    
    const XMLNode scenesNode = doc.getRoot().getChildByName("scenes");
    
    if (scenesNode.isValid() == false)
    {
        printf("Error : no 'scene' node found\n");
        return false;
    }

    for( const auto &scene : scenesNode.getChildren())
    {
        Storyboard::Scene sc;
        if( traverseScene(sc , scene.second))
        {
            sb.addScene( sc);
        }
        
    }
    
    return true;
}

static bool traverseScene( Storyboard::Scene &sc , const XMLNode &scene)
{
    //printf("Got a scene, ID '%s'\n" , scene.getProperty("sceneID").c_str() );
    
    sc.setID( scene.getProperty("sceneID") );
    
    const auto objects = scene.getChildByName("objects");
    
    if( objects.isValid() == false)
    {
        return false;
    }
    
    const auto viewControler = objects.getChildByName("viewController");
    if( viewControler.isValid() == false)
        return false;
    
    
    Storyboard::ViewController vc;
    
    vc.setID( viewControler.getProperty("id"));
    vc.customClass = viewControler.getProperty("customClass");
    vc.customModule = viewControler.getProperty("customModule");
    
    
    const auto viewNode = viewControler.getChildByName("view");
    
    
    if (viewNode.isValid() == false)
    {
        return false;
    }
    
    Storyboard::View view;
    
    vc.view = view;
    
    vc.view.name = viewNode.getName();
    
    const auto subViewsNode = viewNode.getChildByName("subviews");
    
    
    
    if( subViewsNode.isValid())
    {
        for( const auto &subV : subViewsNode.getChildren())
        {
            Storyboard::View view;
            view.name = subV.first;

            view.parameters = subV.second.getProperties();
            
            const auto rectNode = subV.second.getChildByName("rect");
            
            view.rect = { -1.f , -1.f , -1.f ,-1.f};
            if( rectNode.isValid())
            {
                view.rect.origin.x   = std::stof( rectNode.getProperty("x") );
                view.rect.origin.y   = std::stof( rectNode.getProperty("y") );
                view.rect.size.width = std::stof( rectNode.getProperty("width") );
                view.rect.size.height = std::stof( rectNode.getProperty("height") );
            }
            
            
            if( subV.second.getChildByName("connections").isValid() )
            {
                for( const auto &connection : subV.second.getChildByName("connections").getChildren())
                {
                    Storyboard::Connection c;
                    c.type = connection.first;
                    
                    for( const auto &property : connection.second.getProperties())
                    {
                        if (property.first == "destination")
                        {
                            c.destination = property.second;
                        }
                        else
                        {
                            c.parameters.insert(property);
                        }
                    
                    }
                    
                    view.addConnection(c);
                }
            }
            else
            {
                
            }
            vc.view.addSubView( view );
            
        }
    }
    sc.setViewController(vc);
    
    return true;
}

Storyboard::Document::Document( const std::string &fromFile)
{
    ParseFile(*this, fromFile);
}



const Storyboard::Document::Scenes& Storyboard::Document::getScenes() const noexcept
{
    return _scenes;
}

bool Storyboard::Document::addScene( const Storyboard::Scene &scene)
{
    return _scenes.insert(scene).second;
}





std::string Storyboard::Document::getType() const noexcept
{
    return type;
}

std::string Storyboard::Document::getTargetRuntime() const noexcept
{
    return targetRuntime;
}

void Storyboard::Document::setTargetRuntime( const std::string &t)
{
    targetRuntime = t;
}

void Storyboard::Document::setType( const std::string &t)
{
    type = t;
}

void Storyboard::Document::setInitialViewControllerID( const std::string &t)
{
    initialViewControllerID = t;
}

std::string Storyboard::Document::getInitialViewController() const noexcept
{
    for( const auto&s : getScenes() )
    {
        if( s.getViewController().getID() == initialViewControllerID)
            return s.getViewController().customModule + "." + s.getViewController().customClass;
    }
    return ""; //initialViewControllerID;
}
