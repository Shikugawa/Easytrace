class Easytrace
    @@DEFINED_METHODS = [:initialize, :all_enable, :all_disable].freeze
    
    def initialize(*args, &blk)
        @trace ||= []

        args.each do |symbol|
            @trace << TracePoint.new(symbol) do |tr| 
                unless tr.defined_class != 'Easytrace' && @@DEFINED_METHODS.include?(tr.method_id)
                    case tr.event
                    when :call
                        p "#{tr.method_id}: started!"
                    when :return
                        p "#{tr.method_id}: stopped!"
                    end
                end
            end
        end

        all_enable
        yield if block_given?
    end
    
    private
    def all_enable
        @trace.each do |trace_obj|
            trace_obj.enable unless trace_obj.enabled?
        end
    end

    def all_disable
        @trace.each do |trace_obj|
            trace_obj.disable if trace_obj.enabled?
        end
    end
end
