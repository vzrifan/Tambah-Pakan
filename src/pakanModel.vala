class PakanModel{

    public static GLib.List<GLib.HashTable<string, string>>? readFile() {
        var file_path = "/home/vzrifan/Projects/Tambah_Pakan/src/dataPakan.txt";
        var file = File.new_for_path(file_path);
        GLib.List<GLib.HashTable<string, string>> result = new GLib.List<GLib.HashTable<string, string>>();

        try {
            var stream = file.read();
            var scanner = new DataInputStream(stream);
    
            string content = "";
    
            while (true) {
                string? line = scanner.read_line(null);
                if (line == null) {
                    break;
                }
                content += line + "\n";
            }
    
            string[] entries = content.split("\n\n");
    
            foreach (var entry_str in entries) {
                string[] lines = entry_str.split("\n");
    
                var entry_dict = new GLib.HashTable<string, string>(GLib.str_hash, GLib.str_equal);
    
                foreach (var line in lines) {
                    string[] parts = line.split(": ");
    
                    if (parts.length == 2) {
                        entry_dict[parts[0].strip()] = parts[1].strip();
                    }
                }
                result.append(entry_dict);
            }
            stream.close();
            return result;
        } catch (Error e) {
            stderr.printf("Error reading the file: %s\n", e.message);
        }
        return null;
    }

    public void print_entry(GLib.HashTable<string, string> entry) {
        entry.foreach((key, value) => {
            print("%s: %s\n", key, value);
        });
        print("\n");
    }
}