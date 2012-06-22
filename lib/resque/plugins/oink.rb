require 'oink'
require 'oink/utils/hash_utils'
require 'oink/instrumentation'
require 'oink/instrumentation/active_record'
require 'hodel_3000_compliant_logger'

ActiveRecord::Base.send(:include, Oink::Instrumentation::ActiveRecord)
module Resque
  module Plugins
    module Oink

      def oink_logger
        @oink_logger ||= Hodel3000CompliantLogger.new("log/resque-oink.log")
      end


      def before_perform_with_oink_instrumentation(*args)
        ActiveRecord::Base.reset_instance_type_count
      end

      def after_perform_with_oink_instrumentation(*args)
        job_class = if self.kind_of?(Class)
                      self.name
                    else
                      self.class.name
                    end
        oink_logger.info "Oink Action: #{job_class}#perform"
        memory = ::Oink::Instrumentation::MemorySnapshot.memory
        oink_logger.info "Memory usage: #{memory} | PID: #{$$}"

        sorted_list = ::Oink::HashUtils.to_sorted_array(ActiveRecord::Base.instantiated_hash)
        sorted_list.unshift("Total: #{ActiveRecord::Base.total_objects_instantiated}")

        oink_logger.info "Instantiation Breakdown: #{sorted_list.join(' | ')}"

        oink_logger.info("Oink Log Entry Complete")

      end
    end
  end
end
