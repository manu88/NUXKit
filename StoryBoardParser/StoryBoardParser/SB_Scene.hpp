//
//  SB_Scene.hpp
//  StoryBoardParser
//
//  Created by Manuel Deneu on 30/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#ifndef SB_Scene_hpp
#define SB_Scene_hpp

#include <string>
#include "SB_View.hpp"

namespace Storyboard
{
    class ViewController
    {
    public:
        void setID( const std::string &id)
        {
            _id = id;
        }
        std::string getID() const noexcept
        {
            return _id;
        }
        
        
        Storyboard::View view;
        std::string customClass;
        std::string customModule;
        
        Storyboard::Color backGroundColor;
    private:
        std::string _id;
        
        
    };
    
    class Scene
    {
    public:
        
        bool operator<( const Scene& rhs) const
        {
            return _id < rhs._id;
        }
        
        void setID( const std::string &id);
        std::string getID() const noexcept;
        
        
        void setViewController( Storyboard::ViewController& vc);
        //Storyboard::ViewController& getViewController();
        const Storyboard::ViewController& getViewController() const;
    private:
        std::string _id;
        
        Storyboard::ViewController _viewController;
    };
    
    
}

#endif /* SB_Scene_hpp */
