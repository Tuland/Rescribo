=begin
------------------------------------- Class: SignalException < Exception
     Descendents of class +Exception+ are used to communicate between
     +raise+ methods and +rescue+ statements in +begin/end+ blocks.
     +Exception+ objects carry information about the exception---its
     type (the exception's class name), an optional descriptive string,
     and optional traceback information. Programs may subclass
     +Exception+ to add additional information.

------------------------------------------------------------------------

=end
class SignalException < Exception

  def signm
  end

  def signo
  end

end
