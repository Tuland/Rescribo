=begin
-------------------------------------------------- Class: Class < Module
     Classes in Ruby are first-class objects---each is an instance of
     class +Class+.

     When a new class is created (typically using +class Name ... end+),
     an object of type +Class+ is created and assigned to a global
     constant (+Name+ in this case). When +Name.new+ is called to create
     a new object, the +new+ method in +Class+ is run by default. This
     can be demonstrated by overriding +new+ in +Class+:

        class Class
           alias oldNew  new
           def new(*args)
             print "Creating a new ", self.name, "\n"
             oldNew(*args)
           end
         end
     
         class Name
         end
     
         n = Name.new

     _produces:_

        Creating a new Name

     Classes, modules, and objects are interrelated. In the diagram that
     follows, the vertical arrows represent inheritance, and the
     parentheses meta-classes. All metaclasses are instances of the
     class `Class'.

                               +------------------+
                               |                  |
                 Object---->(Object)              |
                  ^  ^        ^  ^                |
                  |  |        |  |                |
                  |  |  +-----+  +---------+      |
                  |  |  |                  |      |
                  |  +-----------+         |      |
                  |     |        |         |      |
           +------+     |     Module--->(Module)  |
           |            |        ^         ^      |
      OtherClass-->(OtherClass)  |         |      |
                                 |         |      |
                               Class---->(Class)  |
                                 ^                |
                                 |                |
                                 +----------------+

------------------------------------------------------------------------


Class methods:
--------------
     new


Instance methods:
-----------------
     allocate, inherited, new, superclass, to_yaml

=end
class Class < Module

  # ------------------------------------------------------- Class#superclass
  #      class.superclass -> a_super_class or nil
  # ------------------------------------------------------------------------
  #      Returns the superclass of _class_, or +nil+.
  # 
  #         File.superclass     #=> IO
  #         IO.superclass       #=> Object
  #         Object.superclass   #=> nil
  # 
  def superclass
  end

  # --------------------------------------------------------- Class#allocate
  #      class.allocate()   =>   obj
  # ------------------------------------------------------------------------
  #      Allocates space for a new object of _class_'s class and does not
  #      call initialize on the new instance. The returned object must be an
  #      instance of _class_.
  # 
  #          klass = Class.new do
  #            def initialize(*args)
  #              @initialized = true
  #            end
  #      
  #            def initialized?
  #              @initialized || false
  #            end
  #          end
  #      
  #          klass.allocate.initialized? #=> false
  # 
  def allocate
  end

  # -------------------------------------------------------------- Class#new
  #      class.new(args, ...)    =>  obj
  # ------------------------------------------------------------------------
  #      Calls +allocate+ to create a new object of _class_'s class, then
  #      invokes that object's +initialize+ method, passing it _args_. This
  #      is the method that ends up getting called whenever an object is
  #      constructed using .new.
  # 
  def new(arg0, arg1, *rest)
  end

  # ---------------------------------------------------------- Class#to_yaml
  #      to_yaml( opts = {} )
  # ------------------------------------------------------------------------
  #      (no description...)
  def to_yaml(arg0, arg1, *rest)
  end

end
