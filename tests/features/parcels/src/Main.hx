
import luxe.Input;
import luxe.Visual;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.Log.def;

class Main extends luxe.Game {


    override function ready() {

        Luxe.renderer.clear_color = new Color().rgb(0xf0f0f0);

        var json_string : String = '
            {
                "textures" : [
                    { "id" : "assets/texture1.png", "filter_min":"nearest", "filter_mag":"nearest" },
                    { "id" : "assets/texture2.png" },
                    { "id" : "assets/texture3.png", "clamp_s":"repeat", "clamp_t":"repeat" },
                    { "id" : "assets/texture4.jpg" },
                    { "id" : "assets/texture5.png" }
                ],
                "shaders" : [
                    { "id":"test1", "frag_id":"assets/shader1.glsl", "vert_id":"default" },
                    { "id":"test2", "frag_id":"assets/shader2.glsl", "vert_id":"default" },
                    { "id":"test3", "frag_id":"assets/shader3.glsl", "vert_id":"default" }
                ],
                "fonts" : [
                    { "id" : "assets/fonts/font1.fnt" },
                    { "id" : "assets/fonts/font2.fnt" },
                    { "id" : "assets/fonts/font3.fnt" },
                    { "id" : "assets/fonts/font4.fnt" },
                    { "id" : "assets/fonts/font5.fnt", "texture_path":"assets/fonts/font5tex/" }
                ],
                "sounds" : [
                    { "id" : "assets/sound1.ogg", "name" : "sound1", "is_stream" : true }
                ],
                "text" : [
                    { "id" : "assets/text1.txt" },
                    { "id" : "assets/text2.txt" },
                    { "id" : "assets/text3.txt" },
                    { "id" : "assets/text4.txt" },
                    { "id" : "assets/text5.txt" }
                ],
                "json" : [
                    { "id" : "assets/json1.json" },
                    { "id" : "assets/json2.json" }
                ],
                "data" : [
                    { "id" : "assets/bytes1" },
                    { "id" : "assets/bytes2" },
                    { "id" : "assets/bytes3" },
                    { "id" : "assets/bytes4" },
                    { "id" : "assets/bytes5" }
                ]
            }
        ';

        parcel = new Parcel();
        parcel.from_json( haxe.Json.parse(json_string) );

        sprites = [];

        var barw : Float = Luxe.screen.w/60;
        var space : Float = barw * 0.2;
        barw -= space;

        for(i in 0 ... 60) {
            var s = new Sprite({
                centered:false,
                pos : new Vector( (barw+space)*i, 0 ),
                size : new Vector( barw, Luxe.screen.h ),
                color : new Color().rgb(0x121212)
            });

            sprites.push( s );
            luxe.tween.Actuate.tween(s.scale, 0.4, {y:0} ).repeat().reflect().delay(Math.random());
        }

        var progress = new ParcelProgress({
            parcel      : parcel,
            background  : new Color(1,1,1,0.85),
            oncomplete  : onloaded
        });

        parcel.load();

    }

    var parcel: Parcel;
    var sprites : Array<Sprite>;

    var s : Float = 0;

    function onloaded( p:Parcel ) {
        trace("All complete :  Total time took " + p.time_to_load);

        trace(Luxe.resources.texture('assets/texture1.png'));
        trace(Luxe.resources.texture('assets/texture3.png'));
    }

    override function onkeyup( e:KeyEvent ) {

        if(e.keycode == Key.key_d) {
            parcel.unload();
        }

        if(e.keycode == Key.key_r) {
            parcel.load();
        }

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    }


}
