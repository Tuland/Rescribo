=begin
---------------------------------------------------------- Class: Object
     +Object+ is the parent class of all classes in Ruby. Its methods
     are therefore available to all objects unless explicitly
     overridden.

     +Object+ mixes in the +Kernel+ module, making the built-in kernel
     functions globally accessible. Although the instance methods of
     +Object+ are defined by the +Kernel+ module, we have chosen to
     document them here for clarity.

     In the descriptions of Object's methods, the parameter _symbol_
     refers to a symbol, which is either a quoted string or a +Symbol+
     (such as +:name+).

------------------------------------------------------------------------


Includes:
---------
     Kernel(Array, Float, Integer, Pathname, String, URI, __method__, `,
     abort, at_exit, autoload, autoload?, binding, binding_n,
     block_given?, breakpoint, callcc, caller, catch, chomp, chomp!,
     chop, chop!, debugger, eval, exec, exit, exit!, fail, fork, format,
     gem, getc, gets, global_variables, gsub, gsub!, instance_exec,
     iterator?, lambda, load, local_variables, log_open_files, loop,
     method_missing, open, open_uri_original_open, orig_open, p, pp,
     pretty_inspect, print, printf, proc, putc, puts, raise, rand,
     readline, readlines, require, scan, scanf, select, set_trace_func,
     sleep, split, sprintf, srand, sub, sub!, syscall, system, test,
     throw, to_ptr, trace_var, trap, untrace_var, warn, y),
     PP::ObjectMixin(pretty_print, pretty_print_cycle,
     pretty_print_inspect, pretty_print_instance_variables)


Constants:
----------
     ARGF:              argf
     ARGV:              rb_argv
     DATA:              f
     ENV:               envtbl
     FALSE:             Qfalse
     IPsocket:          rb_cIPSocket
     MatchingData:      rb_cMatch
     NIL:               Qnil
     PLATFORM:          p
     RELEASE_DATE:      d
     RUBY_COPYRIGHT:    tmp
     RUBY_DESCRIPTION:  tmp
     RUBY_PATCHLEVEL:   INT2FIX(RUBY_PATCHLEVEL)
     RUBY_PLATFORM:     p
     RUBY_RELEASE_DATE: d
     RUBY_VERSION:      v
     SOCKSsocket:       rb_cSOCKSSocket
     STDERR:            rb_stderr
     STDIN:             rb_stdin
     STDOUT:            rb_stdout
     TCPserver:         rb_cTCPServer
     TCPsocket:         rb_cTCPSocket
     TOPLEVEL_BINDING:  rb_f_binding(ruby_top_self)
     TRUE:              Qtrue
     UDPsocket:         rb_cUDPSocket
     UNIXserver:        rb_cUNIXServer
     UNIXsocket:        rb_cUNIXSocket
     VERSION:           v


Class methods:
--------------
     method_added, new


Instance methods:
-----------------
     ==, ===, =~, __id__, __send__, class, clone, dclone, display, dup,
     enum_for, eql?, equal?, extend, freeze, frozen?, hash, id, inspect,
     instance_eval, instance_exec, instance_of?,
     instance_variable_defined?, instance_variable_get,
     instance_variable_set, instance_variables, is_a?, kind_of?, method,
     methods, nil?, object_id, or_ask, private_methods,
     protected_methods, public_methods, remove_instance_variable,
     respond_to?, send, singleton_method_added,
     singleton_method_removed, singleton_method_undefined,
     singleton_methods, taint, tainted?, tap, to_a, to_enum, to_s,
     to_yaml, to_yaml_properties, to_yaml_style, type, untaint

=end
class Object
  include Kernel

  def self.yaml_tag_subclasses?
  end

  def taguri=(arg0)
  end

  # ---------------------------------------------- Object#to_yaml_properties
  #      to_yaml_properties()
  # ------------------------------------------------------------------------
  #      (no description...)
  def to_yaml_properties
  end

  # --------------------------------------------------- Object#to_yaml_style
  #      to_yaml_style()
  # ------------------------------------------------------------------------
  #      (no description...)
  def to_yaml_style
  end

  def taguri
  end

  # --------------------------------------------------------- Object#to_yaml
  #      to_yaml( opts = {} )
  # ------------------------------------------------------------------------
  #      (no description...)
  def to_yaml(arg0, arg1, *rest)
  end

end
