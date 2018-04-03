//
//  test.h
//  StoryBoardParser
//
//  Created by Manuel Deneu on 31/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#ifndef test_h
#define test_h

#include <gtk/gtk.h>
#include <gobject/gsignal.h>


typedef void  (*GCallback2)              (GtkWidget *widget,gpointer data);

static inline void g_signal_connect_with_data(gpointer          instance ,
                                     const gchar     *detailed_signal,
                                     GCallback2      c_handler,
                                     gpointer          data,
                                     GClosureNotify      destroy_data,
                                     GConnectFlags      connect_flags)
{
    g_signal_connect_data (instance, detailed_signal, G_CALLBACK(c_handler), data, destroy_data, connect_flags);
}

static inline void g_signal_connect2(gpointer instance ,
                                      const gchar     *detailed_signal,
                                      GCallback      c_handler
                                    )
{
    g_signal_connect_data (instance, detailed_signal, G_CALLBACK(c_handler), NULL, NULL,(GConnectFlags) 0);
}


static inline bool GtkIsWidget( gpointer instance)
{
    return GTK_IS_WIDGET(instance);
}

static inline GtkContainer* toGtkContainer( gpointer instance)
{
    return  G_TYPE_CHECK_INSTANCE_CAST ((instance), GTK_TYPE_CONTAINER, GtkContainer);
}
static inline GtkButton* toGtkButton( gpointer instance)
{
    return  G_TYPE_CHECK_INSTANCE_CAST ((instance), GTK_TYPE_BUTTON, GtkButton);
}

static inline GtkWindow* toGtkWindow( gpointer instance)
{
    return  G_TYPE_CHECK_INSTANCE_CAST ((instance), GTK_TYPE_WINDOW, GtkWindow);
}

static inline GtkFixed* toGtkFixed( gpointer instance)
{
    return  G_TYPE_CHECK_INSTANCE_CAST ((instance), GTK_TYPE_FIXED, GtkFixed);
}

static inline GtkLabel* toGtkLabel( gpointer instance)
{
    return  G_TYPE_CHECK_INSTANCE_CAST ((instance), GTK_TYPE_LABEL, GtkLabel);
}


#endif /* test_h */
