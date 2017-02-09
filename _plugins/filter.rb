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

    def my_excerpt(content)
      splitor = "<!-- excerpt -->"
      default_length = 500
      p = 0
      while p + splitor.length <= content.length
        if content[p] == splitor[0] and content[p, splitor.length] == splitor
          return content[0, p]
        end
        p += 1
      end
      return content[0, default_length]
    end
    
    def my_ceil(n)
        return n.ceil
    end
  end
end

Liquid::Template.register_filter(Jekyll::MyFilter)
