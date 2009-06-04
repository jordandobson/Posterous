# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{posterous}
  s.version = "0.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jordan Dobson"]
  s.date = %q{2009-05-29}
  s.default_executable = %q{posterous}
  s.description = %q{The Posterous gem provides posting to Posterous.com using your email, password, site id(if you have multiple sites) and your blog content.}
  s.email = ["jordan.dobson@madebysquad.com"]
  s.executables = []
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/posterous", "lib/posterous.rb", "test/test_posterous.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/jordandobson/posterous/tree/master}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{posterous}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{The Posterous gem provides posting to Posterous.com using your email, password, site id(if you have multiple sites) and your blog content. With this gem, you have access to add an entry on posterous by providing these options a title, body text, date, tags, set to autopost, set private, posted by source name and a posted by source link to Posterous. You can include no options or all options.}
  s.test_files = ["test/test_posterous.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 1.8.3"])
    else
      s.add_dependency(%q<hoe>, [">= 1.8.3"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.8.3"])
  end
end

