module Complate
  class MethodProxy

    def initialize(target)
      @target = target

      (@target.methods - 1.methods).each do |m|
        self.define_singleton_method(m) do |*args|
          @target.method(m).call(*convert_args(args))
        end
      end
    end

    def convert_args(args)
      args.map do |arg|
        case arg
        when V8::Array
          arg.to_a
        when V8::Object
          arg.to_h
        else
          arg
        end
      end
    end

  end
end
