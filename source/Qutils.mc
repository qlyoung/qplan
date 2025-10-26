import Toybox.Lang;
import Toybox.System;

module Trolling {
    typedef InvokableThing as interface {
        function invoke(arg as Object?) as Object?;
    };

    // note that Method.invoke() accepts and returns Any, but Any is not exposed
    // as a type. There appears to be a hard coded exception for Method in the
    // type checker which makes this possible?
    typedef Invokable as InvokableThing or Method;

    // And God said "let there be function composition"
    class ChainedMethod {
        private var _methods as Array<Invokable>;

        function initialize(methods as Array<Invokable>) {
            _methods = methods;
        }

        function invoke(arg as Object?) as Object? {
            var result = arg;
            for (var i = 0; i < _methods.size(); i++) {
                result = _methods[i].invoke(result);
            }
            return result as Object?;
        }
    }
}
