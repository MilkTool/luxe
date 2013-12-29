package luxe.utils;

//Portions ported from Three.js http://github.com/mrdoob/three.js

class Maths {
	
	static public var DEG2RAD:Float = Math.PI / 180;
	static public var RAD2DEG:Float = 180 / Math.PI;
	
	static public function fixed( value:Float, precision:Int ) {
		var n = Math.pow(10,precision);
		return (Std.int(value*n) / n);
	}

	static public function clamp (value:Float, a:Float, b:Float) : Float {
		return ( value < a ) ? a : ( ( value > b ) ? b : value );
	}
	
	static public function clampBottom (value:Float, a:Float) : Float {
		return value < a ? a : value;
	}
	

 	public static function wrap_angle( degrees:Float, lower:Float, upper:Float ) {
    	
    	var _radians:Float = degToRad(degrees);
    	var _distance:Float = upper - lower;
      	var _times:Float = Math.floor((degrees - lower) / _distance);
      	
      	return degrees - (_times * _distance);

    } //wrap_angle

    public static function nearest_power_of_two(_value:Int) {
        
        _value--;
        _value |= _value >> 1;
        _value |= _value >> 2;
        _value |= _value >> 4;
        _value |= _value >> 8;
        _value |= _value >> 16;
        _value++;
        
        return _value;

    } //nearest_power_of_two
	
	static public function mapLinear (value:Float, a1:Float, a2:Float, b1:Float, b2:Float) : Float {
		return b1 + ( value - a1 ) * ( b2 - b1 ) / ( a2 - a1 );
	}
	
	
	static public function smoothstep (x:Float, min:Float, max:Float) : Float {
		if (x <= min) return 0;
		if (x >= max) return 1;
		
		x = ( x - min ) / ( max - min );
		return x * x * ( 3 - 2 * x );
	}
	
	
	static public function smootherstep(x:Float, min:Float, max:Float) : Float {
		if (x <= min) return 0;
		if (x >= max) return 1;
		
		x = ( x - min ) / ( max - min );
		return x * x * x * ( x * ( x * 6 - 15 ) + 10 );
	}
	
	
	static public function random16() : Float {
		return ( 65280 * Math.random() + 255 * Math.random() ) / 65535;
	}
	
	
	static public function randInt(low:Int, high:Int) : Int {
		return low + Math.floor(Math.random() * (high - low + 1));
	}
	
	
	static public function randFloat(low:Float, high:Float) : Float {
		return low + Math.random() * (high - low);
	}
	
	
	static public function randFloatSpread(range:Float) : Float {
		return range * (0.5 - Math.random());
	}
	
	
	static public function sign(x:Float) : Int {
		return (x < 0) ? -1 : ((x > 0) ? 1 : 0);
	}
	
	
	static public function degToRad(deg:Float) : Float {
		return deg * DEG2RAD;
	}
	
	
	static public function radToDeg(rad:Float) : Float {
		return rad * RAD2DEG;
	}
	
} //Maths


