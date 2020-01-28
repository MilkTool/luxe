
import luxe.Input;
import luxe.Log.*;

class Main extends luxe.Game {

    override function config(config:luxe.GameConfig) {

        assert(config.user != null);
        assert(config.user.int == 12);
        assert(config.user.float == 1.2);
        assert(config.user.string == 'luxe');
        assert(config.user.test == true);

        return config;

    }

    override function ready() {

        log('config loaded as ' + Luxe.snow.config.user);

    }


    override function onkeyup( e:KeyEvent ) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    }

    override function update(dt:Float) {

    }


}
