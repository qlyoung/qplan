import Toybox.Lang;

module DiveSettings {
    public var scrRate as Float = 0.70;
    public var cylinder as Dictionary = {
        "cylinder_type_name" => "AL80",
        "service_pressure" => 3000,
        "nominal_capacity" => 80,
        "unit_type" => "standard"
    };

    module Segments {
        public var MaxDepth as Number = 100;
    }

    module MinGas {
        public var bottomDepth as Number = 100;
        public var nextGasDepth as Number = 70;
        public var problemSolvingTime as Number = 2;
        public var gasSwitchTime as Number = 1;
    }
}
