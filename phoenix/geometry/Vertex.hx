package phoenix.geometry;

import phoenix.geometry.TextureCoord;
import phoenix.Vector;
import phoenix.Color;

class Vertex {


    public var pos : Vector;
    public var color : Color;
    public var uv : TextureCoordSet;
    public var normal : Vector;


    public inline function new( _pos : Vector, ?_color:Color = null, ?_normal:Vector = null ) {

        uv = new TextureCoordSet();

        pos = _pos;
        color = (_color == null) ? new Color() : _color;
        normal = (_normal == null) ? new Vector() : _normal;

    }

    public inline function clone() : Vertex {

        var _new = new Vertex( pos.clone(), color.clone(), normal.clone() );
            _new.uv = uv.clone();

        return _new;

    }

    public inline function destroy() {
        pos = null;
        color = null;
        normal = null;
        uv.destroy();
        uv = null;
    }


}
