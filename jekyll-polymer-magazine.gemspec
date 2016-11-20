# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "jekyll-polymer-magazine"
  spec.version       = "0.1.0"
  spec.authors       = ["sukso96100"]
  spec.email         = ["sukso96100@gmail.com"]

  spec.summary       = "Polymer Library based magazine style jekyll theme"
  spec.homepage      = "https://youngbin.xyz"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r{^(assets|_layouts|_includes|_sass|LICENSE|README)}i) }

  spec.add_development_dependency "jekyll", "~> 3.3"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "jekyll-paginate", "~> 1.1.0"
end
