# -*- coding: iso-8859-1 -*-
#
# rb_main.rb
# cocoa
#
# Created by M Norrby on 3/5/10.
# Copyright __MyCompanyName__ 2010. All rights reserved.
#

# Loading the Cocoa framework. If you need to load more frameworks, you can
# do that here too.
framework 'Cocoa'

#Synths = ["Yamaha_FB-01"]
$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__), 'yfb01')
#Synths.each do |synth|
#  $LOAD_PATH << File.join(File.dirname(__FILE__), synth)
#end

mac_paths = $LOAD_PATH.select { |path| path =~ %r{/Library/Frameworks/MacRuby} }
mac_paths.each do |path|
  fw_path = NSBundle.mainBundle.privateFrameworksPath.fileSystemRepresentation
  $LOAD_PATH.unshift path.sub(%r{/Library/Frameworks}, fw_path)
end

# Loading all the Ruby project files.
main = File.basename(__FILE__, File.extname(__FILE__))
dir_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
Dir.glob(File.join(dir_path, '*.{rb,rbo}')).map { |x| File.basename(x, File.extname(x)) }.uniq.each do |path|
  if path != main
    require(path)
  end
end

# Starting the Cocoa main loop.
NSApplicationMain(0, nil)
