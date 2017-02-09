module Jekyll
  module MyFilter
	def remove_url(s)
	    p = 0
	    r = ""
	    state = 0
	    # Loop over entire string input.
	    while p < s.length
	            # Find "<a "
	    	if state == 0
			if p+2 < s.length and s[p] == '<' and s[p+1] == 'a' and s[p+2] == ' '
	    			# Find end bracket ">"
	    			while p < s.length and s[p] != '>'
	    				p += 1
	    			end
	    			state = 1
	    		else
	    			r += s[p]
	    		end
	    	# Find "</a>"
	    	else
			if p+3 < s.length and s[p] == '<' and s[p+1] == '/' and s[p+2] == 'a' and s[p+3] == '>'
	    			# Skip "</a>"
	    			p += 3
	    			state = 0
	    		else
	    			r += s[p]
	    		end
	    	end
	            p += 1
	    end
	    return r
	end
  end
end

Liquid::Template.register_filter(Jekyll::MyFilter)
