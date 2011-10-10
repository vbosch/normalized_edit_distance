
begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

task :default => 'test:run'
task 'gem:release' => 'test:run'

Bones {
  name     'normalized_edit_distance'
  authors  'Vicente Bosch'
  email  'vbosch@gmail.com'
  url  'http://github.com/vbosch/normalized_edit_distance'
  ignore_file  '.gitignore'
}

