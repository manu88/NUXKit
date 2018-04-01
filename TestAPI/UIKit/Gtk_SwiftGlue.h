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


typedef void  (*GCallback2)              (gpointer data);

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
    g_signal_connect_data (instance, detailed_signal, G_CALLBACK(c_handler), NULL, NULL, 0);
}
#define g_signal_connect2(instance, detailed_signal, c_handler, data) \
g_signal_connect_data ((instance), (detailed_signal), (c_handler), (data), NULL, (GConnectFlags) 0)

#endif /* test_h */
