/* window.vala
 *
 * Copyright 2023 
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

namespace TambahPakan {
    [GtkTemplate (ui = "/org/example/App/window.ui")]
    public class Window : Gtk.ApplicationWindow {
        [GtkChild]
        private unowned Gtk.Label label;
        [GtkChild]
        private unowned Gtk.HeaderBar header_bar;
        [GtkChild]
        private unowned Gtk.Button tambah;

        construct{
            tambah.clicked.connect(() => tambahPakanForm(this));
        }

        public Window (Gtk.Application app) {
            Object (application: app);
            Gtk.Label title_header_bar = new Gtk.Label("Pakan");
            title_header_bar.get_style_context ().add_class ("title_header_bar");
            header_bar.set_title_widget(title_header_bar);
            header_bar.get_first_child ().get_first_child ().add_css_class ("header_box");

            var css_provider = new Gtk.CssProvider ();
            string path = "/home/vzrifan/Projects/Tambah_Pakan/src/styles.css";
            css_provider.load_from_path (path);
            Gtk.StyleContext.add_provider_for_display (Gdk.Display.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
        }

        public void tambahPakanForm(Gtk.Window parent){
            var form = new Gtk.Dialog();
            form.title = "Tambah Pakan";
            form.transient_for = parent;
            form.destroy_with_parent = false;
            form.set_default_size(600, 800);

            var content_area = form.get_content_area();

            var label1 = new Gtk.Label("ID Pakan");
            content_area.append(label1);
    
            var entry1 = new Gtk.Entry();
            entry1.placeholder_text = "#123123";
            content_area.append(entry1);
    
            var label2 = new Gtk.Label("Nama Pakan");
            content_area.append(label2);
    
            var entry2 = new Gtk.Entry();
            entry2.placeholder_text = "Contoh: pakan ABC";
            content_area.append(entry2);
    
            var button = new Gtk.Button.with_label("Tambah Pakan");
            button.add_css_class("tambah_button");
            button.clicked.connect(() => onButtonClicked(form, entry1.text, entry2.text));
            content_area.append(button);
    
            form.show();
        }

        public static void onButtonClicked(Gtk.Dialog dialog, string idPakan, string namaPakan){
            print("ID Pakan: %s\n", idPakan);
            print("Nama Pakan: %s\n", namaPakan);

            dialog.response(Gtk.ResponseType.CLOSE);
        }
    }
}
