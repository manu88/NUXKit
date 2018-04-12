//
//  SB_Scene.cpp
//  StoryBoardParser
//
//  Created by Manuel Deneu on 30/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#include "include/SB_Scene.hpp"


Storyboard::Scene::Scene():
_viewController(nullptr)
{
    
}
Storyboard::Scene::~Scene()
{
    if( _viewController)
        delete _viewController;
}


void Storyboard::Scene::setID( const std::string &id)
{
    _id = id;
}
std::string Storyboard::Scene::getID() const noexcept
{
    return _id;
}




void Storyboard::Scene::setViewController( const XMLNode& node)
{
    _viewController = new Storyboard::ViewController(node);
}

Storyboard::ViewController* Storyboard::Scene::getViewController() const
{
    return _viewController;
}

Storyboard::ViewController::ViewController(const XMLNode &node):
node(node)
{
    
}
