class OperatorController < NSViewController
	attr_writer :ar_slider, :tl_slider
	attr_accessor :where
	
	def tl_changed(sender)
		puts "tl is"
	end
	
	def initWithNibName(bundle)
		puts "hahahah"
	end
end
