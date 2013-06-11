# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crawler_sample/version'

Gem::Specification.new do |gem|
  gem.name          = "crawler_sample"
  gem.version       = CrawlerSample::VERSION
  gem.authors       = ["Shigeki Doumae"]
  gem.email         = ["shigeki.doumae@gmail.com"]
  gem.description   = %q{This gem is a web crawler sample code.So I don't reccmmend that you use.}
  gem.summary       = %q{This gem is a web crawler sample code.So I don't reccmmend that you use.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "nokogiri"
  gem.add_dependency "open-uri"
  gem.add_dependency "kconv"

end
