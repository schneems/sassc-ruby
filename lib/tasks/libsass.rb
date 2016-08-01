namespace :libsass do
  desc "Compile libsass"
  task :compile do
    if Dir.pwd.end_with?('/ext')
      libsass_path = "libsass"
    else
      libsass_path = "ext/libsass"
    end

    cd libsass_path do
      Rake::Task["lib/libsass.so"].invoke
    end
  end

  file "Makefile" do
    sh "git submodule update --init"
  end

  file "lib/libsass.so" => "Makefile" do
    make_program = ENV['MAKE']
    make_program ||= case RUBY_PLATFORM
                     when /mswin|mingw/
                       'msbuild /m:4 /p:Configuration=Release win/libsass.sln'
                     when /(bsd|solaris)/
                       'gmake lib/libsass.so'
                     else
                       'make lib/libsass.so'
                     end
    sh "#{make_program}"
  end
end
