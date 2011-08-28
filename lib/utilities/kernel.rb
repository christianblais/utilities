module Kernel
  # Add .inspect to any object passed, than call Kernel.raise
  def raiser(*args)
    raise args.collect(&:inspect).join(", ")
  end
end
