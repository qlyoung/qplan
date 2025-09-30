import Toybox.Lang;
import Toybox.Math;

import Constants;

module DiveCalculations {

    // Depth in meters seawater to ambient pressure
    function CalculateAmbientP(depth) as Float {
        return Units.Convert.MswToBar(depth) + 1.0;
    }

    function CalculateDepthConsumptionP(scr, depth, cylinder) as Float {
        return cylinder.volumeToPressure(scr * CalculateAmbientP(depth));
    }

    function CalculateSegmentTable(scr, cylinder, startDepth, interval) as Array<Dictionary> {
        var segments = [];

        for (var depth = startDepth; depth > 0; depth -= interval) {
            segments.add({
                "depth" => depth,
                "segment" => CalculateDepthConsumptionP(scr, depth, cylinder) * Constants.SEGMENT_LENGTH,
            });
        }

        segments.add({
            "depth" => 0.0,
            "segment" => CalculateDepthConsumptionP(scr, 0.0, cylinder) * Constants.SEGMENT_LENGTH,
        });

        return segments;
    }

    function CalculatePO2(fo2 as Float, depth as Float) {
        return fo2 * DiveCalculations.CalculateAmbientP(depth);
    }

    function CalculateDepthForPO2(po2 as Float, fo2 as Float) as Float {
        // PO2 = FO2 * (depth/10 + 1)
        // depth = (PO2/FO2 - 1) * 10
        return (po2 / fo2 - 1.0) * 10.0;
    }

}