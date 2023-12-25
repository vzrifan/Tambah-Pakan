tambah_pakan_sources = [
  'main.vala',
  'window.vala',
  'application.vala',
]

tambah_pakan_deps = [
  dependency('gtk4'),
]

gnome = import('gnome')

tambah_pakan_sources += gnome.compile_resources('tambah_pakan-resources',
  'tambah_pakan.gresource.xml',
  c_name: 'tambah_pakan'
)

executable('tambah_pakan', tambah_pakan_sources,
  vala_args: '--target-glib=2.50',  dependencies: tambah_pakan_deps,
  install: true,
)
