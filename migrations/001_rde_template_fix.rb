require_relative 'utils'
require 'json'

module MigrationUtils
  module RDETemplateFix
    ::RDETemplateFix = MigrationUtils::RDETemplateFix
    CONFIG = {
      deprecated: 'colLang',
      replacements: {
        'colLanguage' => 'eng',
        'colScript' => 'Latn',
      },
      field_updates: {
        order: :update_array,
        visible: :update_array,
        defaults: :update_hash
      }
    }
    def self.update_array(obj)
      did_something = false
      deprecated_idx = obj.index(CONFIG[:deprecated])
      if deprecated_idx
        obj.insert(deprecated_idx, *CONFIG[:replacements].keys)
        obj.delete(CONFIG[:deprecated])
        did_something = true
      end
      did_something
    end

    def self.update_hash(obj)
      did_something = false
      if obj.key? CONFIG[:deprecated]
        obj.merge!(CONFIG[:replacements])
        obj.delete((CONFIG[:deprecated]))
        did_something = true
      end
      did_something
    end
  end
end

Sequel.migration do
  up do
    self[:rde_template].each do |template|
      RDETemplateFix::CONFIG[:field_updates].each do |field, type|
        obj = JSON.parse(template[field])
        did_something = RDETemplateFix.send(type, obj)
        next unless did_something

        self[:rde_template].where(id: template[:id]).update(field => JSON.generate(obj))
      end
    end
  end

  down do
    # We ain't going back!
  end
end
