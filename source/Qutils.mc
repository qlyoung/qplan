import Toybox.Lang;
import Toybox.System;

module Trolling {
   /*
    * And God said "let there be function composition"
    */
   class ChainedMethod {
       private var _methods as Array;

       function initialize(methods as Array) {
           _methods = methods;
       }

       function invoke(arg) {
           var result = arg;
           for (var i = 0; i < _methods.size(); i++) {
               result = _methods[i].invoke(result);
           }
           return result;
       }
   }

   typedef Invokable as interface {
       function invoke(arg);
   };
}
