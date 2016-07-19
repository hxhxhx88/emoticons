module Helpers
    def include_slim(name, options = {}, &block)
        Slim::Template.new("#{name}.slim", options).render(self, &block)
    end
end
