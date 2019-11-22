# RDE Template Fix

Fixes RDE templates created prior to `v2.7.0` to work with `v2.7+`.

## Background

Prior to `v2.7.0` `colLang` was the attribute used to represent
language selection in RDE templates. From `v2.7.0` the data model
for languages was updated and `colLang` and `colScript` attributes
are used for language & script selection in RDE templates. This
plugin deletes references to `colLang` and inserts references to
`colLang` and `colScript`.

## To install:

1. Stop the application
2. Clone the plugin into the `archivesspace/plugins` directory
3. Add `rde_template_fix` to `config.rb`, ensuring to uncomment/remove the # from the front of the relevant AppConfig line.  For example:
`AppConfig[:plugins] = ['local', 'rde_template_fix']`
4. Restart the application
