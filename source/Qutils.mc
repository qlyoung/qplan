import Toybox.Lang;
import Toybox.System;

// Test if a value is within a given precision of an expected value
function CloseEnough(value as Numeric, expected as Numeric, precision as Numeric) as Boolean {
    return value > expected - precision && value < expected + precision;
}

// Polytype for 32 bit values
typedef SmallNumber as Number or Float;

function CompareValue(a as Object?, b as Object?) as Boolean {
    if (a == null || b == null) { return b == a; }
    if (b instanceof Dictionary and a instanceof Dictionary) {
        return CompareDict(a, b);
    }
    if (b instanceof Array and a instanceof Array) {
        return CompareArray(a, b);
    }
    return (b as Object).equals(a as Object);
}

// Array comparator. Two arrays are equal if they have the same elements in the
// same order
function CompareArray(a as Array, b as Array) as Boolean {
    if (a.size() != b.size()) { return false; }
    for (var i = 0; i < a.size(); i++) {
        var ael = a[i] as Object?;
        var bel = b[i] as Object?;
        if (CompareValue(ael, bel)) { continue; }
        else { return false; }
    }

    return true;
}

// Dict comparator. If a and b have the same (k, v) pairs they are equal.
function CompareDict(a as Dictionary, b as Dictionary) as Boolean {
    var aKeys = a.keys();
    var bKeys = b.keys();
    if (aKeys.size() != bKeys.size()) { return false; }
    for (var i = 0; i < aKeys.size(); i++) {
        if (!b.hasKey(aKeys[i])) { return false; }
        var bval = b[aKeys[i]] as Object?;
        var aval = a[aKeys[i]] as Object?;

        if (CompareValue(aval, bval)) { continue; }
        else { return false; }
    }

    return true;
}

// And God said "let there be function composition"
typedef InvokableThing as interface {
    function invoke(arg as Object?) as Object?;
};

typedef Invokable as InvokableThing or Method;

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
