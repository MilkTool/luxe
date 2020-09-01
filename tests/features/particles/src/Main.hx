
import luxe.Vector;
import luxe.Color;
import luxe.Input;
import luxe.Entity;
import luxe.Particles;
import luxe.Sprite;

import phoenix.Batcher;


class Main extends luxe.Game {


    var mouse : Vector;

    var glowing : Batcher;
    var particle_system : Entity;
    var particles : ParticleSystem;

    var ss : Sprite;


    override function config(config:luxe.GameConfig) {

        config.preload.textures.push({ id:'assets/flame.png' });
        config.preload.textures.push({ id:'assets/smoke.png' });
        config.preload.textures.push({ id:'assets/embers.png' });

        return config;

    }


    override function ready() {

        mouse = new Vector();


        var t1 = Luxe.resources.texture('assets/flame.png');
        var t2 = Luxe.resources.texture('assets/smoke.png');
        var t3 = Luxe.resources.texture('assets/embers.png');

        particles = new ParticleSystem({name:'particles'});

        glowing = Luxe.renderer.create_batcher({ name:'glowing', camera:Luxe.camera.view });

        particles.add_emitter({
            name : 'flames',
            particle_image:t1,
            pos : new Vector(),
            start_size:new Vector(96,64),
            end_size:new Vector(20,20),
            gravity : new Vector(0,-90),
            life:0.9,
            depth:2,
            batcher: glowing,
            rotation_random:360,
            emit_time : 0.05
        });

        ss = new Sprite({
            pos : new Vector(),
            size : new Vector(4,4)
        });

        particles.add_emitter({
            name : 'smoke',
            particle_image : t2,
            start_color : new Color(0.0,0.0,0.0,0.7),
            end_color : new Color(0.3,0.3,0.3,0),
            start_size : new Vector(80,80),
            end_size : new Vector(200,200),
            end_size_random : new Vector(40,40),
            gravity : new Vector(0,-40),
            life : 1.2,
            rotation_random:360,
            depth:1,
            emit_time : 0.2
        });

        particles.add_emitter({
            name : 'embers',
            particle_image : t3,
            end_color : new Color(0,0,0,0).rgb(0xff8a00),
            start_size : new Vector(32,32),
            end_size : new Vector(64,64),
            gravity : new Vector(0,-90),
            life : 0.8,
            end_speed : 0,
            depth:3,
            batcher: glowing,
            emit_time : 0.3
        });

        particles.pos = Luxe.screen.mid;

        glowing.on(prerender, function(_){ Luxe.renderer.blend_mode(BlendMode.src_alpha, BlendMode.one); });
        glowing.on(postrender, function(_){ Luxe.renderer.blend_mode(); });

    }

    override function onmousemove( e:MouseEvent ) {

        mouse.set_xy(e.x,e.y);
        particles.pos = mouse;

        ss.pos = mouse;

    }

    override function onmousedown( e:MouseEvent ) {

        mouse.set_xy(e.x,e.y);

            //pause particles with left click
        if(e.button == MouseButton.left) {

            particles.paused = !particles.paused;

        } else {

                //stop emission with right click
            if(particles.enabled) {
                particles.stop();
            } else {
                particles.start();
            }

        }

    }

    override function onmouseup( e:MouseEvent ) {

        mouse.set_xy(e.x,e.y);

    }

    override function onkeyup( e:KeyEvent ) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    }


}
