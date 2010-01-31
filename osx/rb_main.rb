#
# rb_main.rb
# FB-01_Editor
#
# Created by M Norrby on 1/31/10.
# Copyright __MyCompanyName__ 2010. All rights reserved.
#

# Loading the Cocoa framework. If you need to load more frameworks, you can
# do that here too.
framework 'Cocoa'

$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__), 'yfb01')

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
