require 'rspec/core/formatters/documentation_formatter'

class NoPendingFormatter < RSpec::Core::Formatters::DocumentationFormatter
  RSpec::Core::Formatters.register self,
                                   :example_group_started,
                                   :example_group_finished,
                                   :example_passed,
                                   :example_failed,
                                   :start,
                                   :stop,
                                   :seed,
                                   :dump_pending,
                                   :dump_summary

  # suppress pending example output
  def example_pending(notification)
    # no-op: do not print pending examples
  end

  # override summary to omit pending count
  def dump_summary(summary)
    output.puts "Finished in #{summary.formatted_duration} seconds"
    output.puts "#{summary.example_count} examples, #{summary.failure_count} failures"
  end

  # suppress pending list output
  def dump_pending(notification)
    # no-op
  end
end
