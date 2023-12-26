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
        [GtkChild]
        private unowned Gtk.Grid grid;
        [GtkChild]
        private unowned Gtk.Box container;

        construct{
            tambah.clicked.connect(() => tambahPakanForm());
            PakanModel dataPakan = new PakanModel();
            GLib.List<GLib.HashTable<string, string>> entry = dataPakan.readFile();
            addTable(entry);
            if(grid.get_first_child().name == null){
                container.get_last_child().hide();
                addImg();
            };
        }

        public Window (Gtk.Application app) {
            Object (application: app);
            Gtk.Label title_header_bar = new Gtk.Label("Pakan");
            title_header_bar.get_style_context ().add_class ("title_header_bar");
            header_bar.set_title_widget(title_header_bar);
            header_bar.get_first_child ().get_first_child ().add_css_class ("header_box");

            var css_provider = new Gtk.CssProvider ();
            string path = "/home/vzrifan/Projects/Tambah-Pakan/src/styles.css";
            css_provider.load_from_path (path);
            Gtk.StyleContext.add_provider_for_display (Gdk.Display.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
        }

        public void addTable(GLib.List<GLib.HashTable<string, string>> entries){
            int i = 0;
            int j = 0;
            int k = 0;
            entries.foreach((entry)=>{ 
                Gtk.Grid box = new Gtk.Grid();
                entry.foreach((key, value) => {
                    Gtk.Label label = new Gtk.Label(key + ": " + value);
                    label.set_name("label");
                    box.attach(label, j, i);
                    i+=1;
                    //  print("%s: %s\n", key, value);
                });
                j+=1;
                box.add_css_class("box");
                grid.attach(box, j, k);
                if(j==4){
                    j=0;
                    k+=1;
                }
                //  print("\n");
            });
            grid.remove(grid.get_last_child());
        }

        public void addImg(){
            var image = new Gtk.Image();
            var pixbuf = new Gdk.Pixbuf.from_file("/home/vzrifan/Projects/Tambah-Pakan/src/img/empty_pakan.png");
            var label = new Gtk.Label("Anda belum memiliki pakan");
            image.set_from_pixbuf(pixbuf);
            image.set_size_request(300, 700);
            container.append(label);
            label.add_css_class("label_null");
            container.append(image);
        }

        public void tambahPakanForm(){
            var form = new Gtk.Dialog();
            form.title = "Tambah Pakan";
            form.transient_for = this;
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

            var label3 = new Gtk.Label("Jenis Pakan");
            content_area.append(label3);

            Gee.ArrayList<string> jenisPakanValues = new Gee.ArrayList<string>();
            jenisPakanValues.add("Pilih");
            jenisPakanValues.add("Jenis Pakan 1");
            jenisPakanValues.add("Jenis Pakan 2");
            jenisPakanValues.add("Jenis Pakan 3");
            jenisPakanValues.add("Jenis Pakan 4");
            var jenisPakanCombo = new Gtk.ComboBoxText();
            foreach (var value in jenisPakanValues)
            {
                jenisPakanCombo.append_text(value);
            }
            jenisPakanCombo.set_active(0);
            content_area.append(jenisPakanCombo);

            var label5 = new Gtk.Label("Tanggal");
            content_area.append(label5);

            var tanggalCalendar = new Gtk.Calendar();
            content_area.append(tanggalCalendar);

            var label6 = new Gtk.Label("Berat");
            content_area.append(label6);
    
            var entry6 = new Gtk.Entry();
            content_area.append(entry6);

            var label7 = new Gtk.Label("Modal");
            content_area.append(label7);
    
            var entry7 = new Gtk.Entry();
            content_area.append(entry7);
    
            var button = new Gtk.Button.with_label("Tambah Pakan");
            button.add_css_class("tambah_button");
            
            form.present();

            button.clicked.connect(() => onButtonClicked(form, 
                entry1.text, 
                entry2.text, 
                jenisPakanValues[jenisPakanCombo.get_active()],
                tanggalCalendar.get_date(),
                entry6.text,
                entry7.text
            ));
            content_area.append(button);
        }

        public static void onButtonClicked(Gtk.Dialog dialog, 
            string idPakan, 
            string namaPakan, 
            string jenisPakan, 
            GLib.DateTime tanggal, 
            string berat, 
            string modal){
            if (jenisPakan == "Pilih") {
                jenisPakan = "";
            }

            var file = File.new_for_path("/home/vzrifan/Projects/Tambah-Pakan/src/dataPakan.txt");
            var stream = file.append_to(FileCreateFlags.NONE);

            string output = "ID Pakan: " + idPakan + "\n";
            output += "Nama Pakan: " + namaPakan + "\n";
            output += "Jenis Pakan: " + jenisPakan + "\n";
            output += "Tanggal: " + tanggal.get_day_of_month().to_string() + "\n";
            output += "Bulan: " + tanggal.get_month().to_string() + "\n";
            output += "Tahun: " + tanggal.get_year().to_string() + "\n";
            output += "Tanggal: " + tanggal.format("%d-%m-%y") + "\n";
            output += "Berat: " + berat + "\n";
            output += "Modal: " + modal + "\n\n";
            stream.write(output.data);
            stream.close();

            dialog.destroy();

            Window window = (Window)dialog.get_transient_for();
            
            var lastChild = window.container.get_last_child();
            if (lastChild is Gtk.Image) {
                window.container.remove(lastChild);
            }

            var lastChild2 = window.container.get_last_child();
            if (lastChild2.get_css_classes()[0] == "label_null"){
                window.container.remove(lastChild2);
            }

            window.addTable(PakanModel.readFile());
            window.container.get_last_child().show();
        }
    }
}