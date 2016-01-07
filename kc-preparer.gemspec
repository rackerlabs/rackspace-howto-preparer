Gem::Specification.new do |s|
  s.name = 'kc-preparer'
  s.version = '0.0.0'
  s.date = '2015-11-17'
  s.summary = "KC Preparer"
  s.authors = ["Self Service Development"]
  s.files = Dir.glob("{bin,lib}/**/*") + %w(README.md)
  s.executables  = ['kc-preparer']
  s.require_path = 'lib'

  s.add_runtime_dependency "redcarpet", ["= 2.3.0"]
  s.add_runtime_dependency "rest-client", ["=  1.8.0"]
  s.add_runtime_dependency "json", ['= 1.8.3']

  s.add_development_dependency "rake", ["= 10.4.2"]
  s.add_development_dependency "rspec", ["= 3.4.0"]
  s.add_development_dependency "mocha", ["= 1.1.0"]
  s.add_development_dependency "webmock", ["= 1.22.3"]
  s.add_development_dependency "vcr", ["= 3.0.0"]
  s.add_development_dependency "simplecov", ["= 0.11.1"]
end
