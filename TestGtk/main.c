#include <gtk/gtk.h>
#include <gobject/gsignal.h>

#include <stdlib.h>
#include <gtk/gtk.h>

/* Create a new hbox with an image and a label packed into it
 * and return the box. */



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
    
    gtk_fixed_put( GTK_FIXED(window2 ), button, 10, 10);// (GTK_CONTAINER (window2), button);
    gtk_container_add (GTK_CONTAINER (window), window2);
    
    gtk_widget_show (window2);
    gtk_widget_show (window);
    
    /* Rest in gtk_main and wait for the fun to begin! */
    gtk_main ();
    
    return 0;
}
