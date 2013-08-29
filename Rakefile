require "bundler/gem_tasks"
require 'ronn'


namespace :man do
  directory "man"

  Dir["man/*.ronn"].each do |ronn|
    basename = File.basename(ronn, ".ronn")
    roff = "man/#{basename}"

    file roff => ["man", ronn] do
      sh "#{Gem.ruby} -S ronn --roff --pipe #{ronn} > #{roff}"
    end

    file "#{roff}.txt" => roff do
      sh "groff -Wall -mtty-char -mandoc -Tascii #{roff} | col -b > #{roff}.txt"
    end

    task :build_all_pages => "#{roff}.txt"
  end

  desc "Build the man pages"
  task :build => "man:build_all_pages"

  desc "Clean up from the built man pages"
  task :clean do
    rm "man/addrex.1"
    rm "man/addrex.1.txt"
  end
end

task :build => ["man:clean", "man:build"]
task :release => ["man:clean", "man:build"]
