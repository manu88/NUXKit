//
//  StoryboardDocument.hpp
//  StoryBoardParser
//
//  Created by Manuel Deneu on 30/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#ifndef StoryboardDocument_hpp
#define StoryboardDocument_hpp

#include <string>
#include <set>
#include "SB_Scene.hpp"
#include "XMLDocument.hpp"

//class XMLNode;

namespace Storyboard
{
    class Document
    {
    public:
        using Scenes = std::set<Storyboard::Scene>;
        
        Document( const std::string &fromFile);
        

        
        bool addScene( const Storyboard::Scene &scene);
        
        const Scenes& getScenes() const noexcept;
        
        void setTargetRuntime( const std::string &t);
        std::string getTargetRuntime() const noexcept;
        
        void setType( const std::string &t);
        std::string getType() const noexcept;
        
        void setInitialViewControllerID( const std::string &t);
        const Storyboard::ViewController* getInitialViewController() const noexcept;
        
        XMLNode getRootNode();
    private:
        
        static bool ParseFile( Document& sb, const std::string &file);
        
        XMLDocument _doc;
        Scenes _scenes;
        
        std::string targetRuntime;
        std::string type;
        
        std::string initialViewControllerID;
    };
}

#endif /* StoryboardDocument_hpp */
