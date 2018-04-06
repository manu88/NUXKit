//
//  GtkDrawableContainer.c
//  NUXKit
//
//  Created by Manuel Deneu on 05/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#include "GtkDrawableContainer.h"


GtkDrawableContainer* GtkDrawableContainer_new(void)
{
    return (GtkDrawableContainer*) gtk_fixed_new();
}
