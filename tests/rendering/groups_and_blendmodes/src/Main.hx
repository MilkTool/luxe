
import luxe.Input;
import luxe.Sprite;
import luxe.Vector;
import phoenix.Batcher;

class Main extends luxe.Game {


    var level_sprite : Sprite;

    var luxe_sprite1 : Sprite;
    var luxe_sprite2 : Sprite;
    var luxe_sprite3 : Sprite;
    var luxe_sprite4 : Sprite;
    var luxe_sprite5 : Sprite;

    var batch1 : Batcher;
    var batch2 : Batcher;
    var batch3 : Batcher;

    override function config(config:luxe.GameConfig) {

        config.preload.textures.push({ id:'assets/level.png' });
        config.preload.textures.push({ id:'assets/luxe.png' });
        config.preload.textures.push({ id:'assets/logo.png' });

        return config;

    }


    override function ready() {

        batch1 = Luxe.renderer.create_batcher({ name:'batch1', camera:Luxe.camera.view });
        batch2 = Luxe.renderer.create_batcher({ name:'batch2', camera:Luxe.camera.view });
        batch3 = Luxe.renderer.create_batcher({ name:'batch3', camera:Luxe.camera.view });

        var level_texture = Luxe.resources.texture('assets/level.png');
        var luxe_texture = Luxe.resources.texture('assets/luxe.png');
        var logo_texture = Luxe.resources.texture('assets/logo.png');

        level_sprite = new Sprite({
            texture : level_texture,
            pos : new Vector(Luxe.screen.w/2,Luxe.screen.h/2)
        });


        level_texture.filter_min = level_texture.filter_mag = phoenix.Texture.FilterType.nearest;
        level_sprite.scale = new Vector(Luxe.screen.w/240,Luxe.screen.h/160);

        var spacing = Luxe.screen.w/6;
        var half_spacing = (Luxe.screen.w/4)/2;
        var mid = Luxe.screen.h/2;

        luxe_sprite1 = new Sprite({
            texture : luxe_texture,
            pos : new Vector( spacing * 1, mid ),
            size : new Vector( half_spacing, half_spacing ),
            batcher: batch1
        });

        luxe_sprite2 = new Sprite({
            texture : luxe_texture,
            pos : new Vector( spacing * 2, mid ),
            size : new Vector( half_spacing, half_spacing ),
            batcher: batch2
        });

        luxe_sprite3 = new Sprite({
            texture : luxe_texture,
            pos : new Vector( spacing * 3, mid ),
            size : new Vector( half_spacing, half_spacing ),
            batcher: batch3
        });

        luxe_sprite4 = new Sprite({
            texture : luxe_texture,
            pos : new Vector( spacing * 4, mid ),
            size : new Vector( half_spacing, half_spacing ),
            batcher: batch3
        });

        luxe_sprite5 = new Sprite({
            texture : logo_texture,
            pos : new Vector( spacing * 5, mid ),
            size : new Vector( half_spacing, half_spacing ),
            batcher: batch3
        });

            //for the group, we set the blend mode to additive
        batch1.on(prerender, function(b:Batcher){ Luxe.renderer.blend_mode(BlendMode.src_alpha, BlendMode.one); });
            //then we reset it when this group is done rendering
        batch1.on(postrender, function(b:Batcher){ Luxe.renderer.blend_mode(); });

            //for this geometry, we set the blending directly
        luxe_sprite3.blend_src_rgb = BlendMode.dst_color;
        luxe_sprite3.blend_src_alpha = BlendMode.dst_color;
        luxe_sprite3.blend_dest_rgb = BlendMode.one_minus_src_alpha;
        luxe_sprite3.blend_dest_alpha = BlendMode.one_minus_src_alpha;

            //for this geometry, we set the blending using the shortcuts
        luxe_sprite4.blend_src = BlendMode.dst_color;
        luxe_sprite4.blend_dest = BlendMode.src_color;

            //and this one, disable blending
        luxe_sprite5.blend_disabled = true;

    }

    override function onkeyup( e:KeyEvent ) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    }


}
