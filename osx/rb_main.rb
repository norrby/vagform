#
# rb_main.rb
# FB-01_Editor
#
# Created by M Norrby on 1/12/10.
# Copyright __MyCompanyName__ 2010. All rights reserved.
#

# Loading the Cocoa framework. If you need to load more frameworks, you can
# do that here too.
framework 'Cocoa'

$LOAD_PATH << File.join(File.dirname(__FILE__), 'midi-lex/lib')
$LOAD_PATH << File.join(File.dirname(__FILE__), 'Yamaha_FB-01')

#if rubygems are required somewhere, all this is needed
#libs = NSBundle.mainBundle.resourcePath.fileSystemRepresentation + "/../Frameworks/MacRuby.framework/Versions/Current/usr/lib/ruby/1.9.0"
#rbconfig_dir = NSBundle.mainBundle.resourcePath.fileSystemRepresentation + "/../Frameworks/MacRuby.framework/Versions/Current/usr/lib/ruby/1.9.0/universal-darwin10.0"
#$LOAD_PATH << libs
#$LOAD_PATH << rbconfig_dir

# Loading all the Ruby project files.
dir_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
Dir.entries(dir_path).each do |path|
  if path != File.basename(__FILE__) and path[-3..-1] == '.rb'
    require(path)
  end
end

# Starting the Cocoa main loop.
NSApplicationMain(0, nil)
