Pod::Spec.new do |s|
  s.name = 'Codice'
  s.version = '1.2.0'
  s.summary = 'Codice is a very lightweight, Foundation-compatible persistence interface.'
  s.description = <<-DESC
Codice is a very lightweight, Foundation-compatible persistence interface. In concrete terms, it implements a Swifty wrapper over Foundation's keyed archive API.
                       DESC
  s.homepage = 'https://github.com/fellipecaetano/Codice'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Fellipe Caetano' => 'fellipe.caetano4@gmail.com.com' }
  s.source = { :git => 'https://github.com/fellipecaetano/Codice.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.source_files = 'Codice/Classes/**/*'
  s.dependency 'PromiseKit', '~> 4.0'
end
