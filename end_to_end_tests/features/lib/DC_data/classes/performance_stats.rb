module DC_data
  class Performance_stats
    include Capybara::DSL

    def initialize
    end

    def collect_garbage
      page.execute_script("gc()")
      system('sleep 2')
    end

    def return_stats
      return page.execute_script("return window.performance.memory")
    end
  end
end