
import luxe.Input;

class Main extends luxe.Game {


    var pan : Float = 1;


    override function ready() {

        Luxe.audio.create('assets/sound.ogg', 'sound');
        Luxe.audio.create('assets/ambience.ogg', 'music');

        Luxe.audio.loop('music');

        // //pan from left to right and back
        // luxe.tween.Actuate.tween(this, 20, { pan:-1 })
        //     .repeat()
        //     .reflect()
        //     .onUpdate(function(){
        //         Luxe.audio.pan('music', pan);
        //     });

    } //ready

    override function onmouseup( e:MouseEvent ) {
        if(e.button == MouseButton.left) {
            Luxe.audio.play('sound');
        }
    }

    override function onkeyup( e:KeyEvent ) {

        if(e.keycode == Key.KEY_r) {
            // Luxe.audio.position('music', 0);
        }

        if(e.keycode == Key.KEY_l) {
            Luxe.audio.play('sound');
        }

        if(e.keycode == Key.KEY_s) {
            Luxe.audio.stop('music');
        }
        if(e.keycode == Key.KEY_p) {
            Luxe.audio.play('music');
        }

        if(e.keycode == Key.ESCAPE) {
            Luxe.shutdown();
        }

    } //onkeyup


} //Main
