#include <gtk/gtk.h>
#include <gobject/gsignal.h>

#include <stdlib.h>
#include <gtk/gtk.h>
#include <assert.h>
#include <cairo.h>
#include "CustomWidget.h"

/* Create a new hbox with an image and a label packed into it
 * and return the box. */

static GtkWidget* toggle = NULL;

/* Our usual callback function */
static void callback( GtkWidget *widget,
                     gpointer   data )
{
    g_print ("Hello again - %s was pressed\n", (char *) data);
    
    GdkRGBA color;
    color.alpha = 1.0;
    color.red = 1.0;
    color.green = 0.0;
    color.blue = 0.0;
    gtk_widget_override_background_color(widget, GTK_STATE_FLAG_NORMAL, &color);
    //gtk_widget_show(widget);
}


static void callbackToggle( GtkWidget *widget,
                           GParamSpec *pSpec,
                           gpointer   data )
{
    assert(widget == toggle);
    assert(widget == data);
    
}

gboolean
draw_callback (GtkWidget *widget, cairo_t *cr, gpointer data)
{
    guint width, height;
    GdkRGBA color;
    GtkStyleContext *context;
    
    context = gtk_widget_get_style_context (widget);
    
    width = gtk_widget_get_allocated_width (widget);
    height = gtk_widget_get_allocated_height (widget);
    
    gtk_render_background (context, cr, 0, 0, width, height);
    
    cairo_arc (cr,
               width / 2.0, height / 2.0,
               MIN (width, height) / 2.0,
               0, 2 * G_PI);
    
    gtk_style_context_get_color (context,
                                 gtk_style_context_get_state (context),
                                 &color);
    gdk_cairo_set_source_rgba (cr, &color);
    
    cairo_fill (cr);
    
    return FALSE;
}

int main( int   argc,
         char *argv[] )
{
    /* GtkWidget is the storage type for widgets */
    GtkWidget *window;
    GtkWidget *window2;
    GtkWidget *button;
    
    //GtkWidget *box;
    
    gtk_init (&argc, &argv);
    
    
    
    /* Create a new window */
    window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
    window2 = gtk_fixed_new();
    
    gtk_window_set_title (GTK_WINDOW (window), "Pixmap'd Buttons!");
    
    /* It's a good idea to do this for all windows. */
    g_signal_connect (window, "destroy",
                      G_CALLBACK (gtk_main_quit), NULL);
    
    g_signal_connect (window, "delete-event",
                      G_CALLBACK (gtk_main_quit), NULL);
    
    /* Sets the border width of the window. */
    gtk_container_set_border_width (GTK_CONTAINER (window), 10);
    
    /* Create a new button */
    button = gtk_button_new ();
    
    /* Connect the "clicked" signal of the button to our callback */
    g_signal_connect (button, "clicked",
                      G_CALLBACK (callback), (gpointer) "cool button");
    
    /* This calls our box creating function */
    //box = xpm_label_box ("info.xpm", "cool button");
    
    /* Pack and show all our widgets */
    //gtk_widget_show (box);
    
    //gtk_container_add (GTK_CONTAINER (button), box);
    
    gtk_widget_show (button);
    
    toggle = gtk_switch_new();
    
    //g_signal_connect(toggle , "notify::active", G_CALLBACK(callbackToggle) , toggle);
    
    
    g_signal_connect( GTK_SWITCH( toggle ), "notify::active", G_CALLBACK(callbackToggle), toggle);
    gtk_widget_show (toggle);
    
    
    GtkWidget *custom = gtk_drawing_area_new();
    gtk_widget_set_size_request (custom, 100, 100);
    g_signal_connect (G_OBJECT (custom), "draw",
                      G_CALLBACK (draw_callback), NULL);
    
    
    
    gtk_widget_show (custom);
    gtk_fixed_put( GTK_FIXED(window2 ), button, 10, 10);// (GTK_CONTAINER (window2), button);
    gtk_fixed_put( GTK_FIXED(window2 ), toggle, 10, 100);// (GTK_CONTAINER (window2), button);
    gtk_fixed_put( GTK_FIXED(window2 ), custom, 10, 200);
    
    gtk_container_add (GTK_CONTAINER (window), window2);
    
    gtk_widget_show (window2);
    gtk_widget_show (window);
    
    /* Rest in gtk_main and wait for the fun to begin! */
    gtk_main ();
    
    return 0;
}
