//
//  SB_Scene.cpp
//  StoryBoardParser
//
//  Created by Manuel Deneu on 30/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#include "SB_Scene.hpp"


void Storyboard::Scene::setID( const std::string &id)
{
    _id = id;
}
std::string Storyboard::Scene::getID() const noexcept
{
    return _id;
}




void Storyboard::Scene::setViewController( Storyboard::ViewController& vc)
{
    _viewController = vc;
}
const Storyboard::ViewController& Storyboard::Scene::getViewController() const
{
    return _viewController;
}
