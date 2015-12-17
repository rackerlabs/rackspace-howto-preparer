

class KCPreparer::Directory

  # grab all the markdown files that are descendants of the specified path
  def self.get_paths(config)
    Dir.glob(File.join('.', config[:kc_root], '**', '*.{md,html}'))
  end
end
