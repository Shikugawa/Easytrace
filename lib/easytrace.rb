require "easytrace/version"

module Easytrace
    @@DEFINED_METHODS = [:start, :stop, :all_enable, :all_disable].freeze
    
    def start(*args, &blk)
        @trace ||= []
        blc = block_given? ? Proc.new{ |tr| p tr unless tr.defined_class != 'EasyTrace' && @@DEFINED_METHODS.include?(tr.method_id) } : blk
        args.each do |opts|
            @trace << TracePoint.new(opts, &blc)
        end

        all_enable
    end

    def stop
       all_disable
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
