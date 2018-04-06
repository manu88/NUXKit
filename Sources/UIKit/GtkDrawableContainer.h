//
//  GtkDrawableContainer.h
//  NUXKit
//
//  Created by Manuel Deneu on 05/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#ifndef GtkDrawableContainer_h
#define GtkDrawableContainer_h

#include <stdio.h>
#include <gtk/gtk.h>


typedef struct
{
    GtkFixed *fixed;
    
}GtkDrawableContainer;

GtkDrawableContainer* GtkDrawableContainer_new(void);

//GtkWidget* GtkDrawableContainer_toGtkWidget( GtkDrawableContainer* container);

#endif /* GtkDrawableContainer_h */
