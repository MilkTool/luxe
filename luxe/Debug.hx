package luxe;

import luxe.Engine;
import luxe.Input;
import luxe.Ev;

import luxe.debug.Inspector;
import luxe.debug.DebugView;

import phoenix.Camera;
import phoenix.Batcher;
import phoenix.BitmapFont;
import phoenix.geometry.Geometry;
import phoenix.geometry.QuadGeometry;

import luxe.utils.Maths;
import luxe.Log._debug;
import luxe.Log.assert;

using StringTools;

@:allow(luxe.Engine)
class Debug {

    public var app : Engine;
    public var visible (default, set) : Bool = false;

    public var inspector : Inspector;
    public var overlay : QuadGeometry;

    public var batcher : Batcher;
    public var view : Camera;
    public var debug_font : BitmapFont;

        //track a delta frame average
    public var dt_average : Float = 0;
    public var dt_average_accum : Float = 0;
    public var dt_average_span : Int = 60;
    public var dt_average_count : Int = 0;

//views
    public var current_view_index = 0;
    public var last_view_index = 0;
    public var current_view : DebugView;
    public static var views : Array<DebugView>;

    public var padding : Vector;

//Profile path
    public var profile_path : String = "profile.txt";
    public var profiling : Bool = false;

    function new( _app:Engine ) {

        app = _app;

    }

//public API

        /** Fetch the instance of the debug view for manipulation by name */
    public function get_view<T>(_name:String) : T {

        for(view in views) {

            if(view.name == _name) {
                return cast view;
            }

        }

        return null;

    }

    #if !luxe_noprofile

        /** start a profiling section for the profiler debug view */
        public function start(_name:String, ?_max:Float) {
            #if !no_debug_console
                if(!app.headless) {
                    luxe.debug.ProfilerDebugView.start(_name, _max);
                }
            #end
        }

            /** end a profiling section for the profiler debug view */
        public function end(_name:String) {
            #if !no_debug_console
                if(!app.headless) {
                    luxe.debug.ProfilerDebugView.end(_name);
                }
            #end
        }
    #end

//Internal

    function init() {

        views = [];

        #if !no_debug_console

            views.push(new luxe.debug.TraceDebugView(this));
            views.push(new luxe.debug.StatsDebugView(this));
            //views.push(new luxe.debug.BatcherDebugView(this));
            views.push(new luxe.debug.ProfilerDebugView(this));
            views.push(new luxe.debug.SceneDebugView(this));

            current_view = views[0];

            haxe.Log.trace = internal_trace;

        #end

        _debug('\t debug initialized.');

    }

    function create_debug_console() {

        #if !no_debug_console

            app.on(Ev.keyup, keyup);
            app.on(Ev.keydown, keydown);
            app.on(Ev.mouseup, mouseup);
            app.on(Ev.mousedown, mousedown);
            app.on(Ev.mousemove, mousemove);
            app.on(Ev.mousewheel, mousewheel);
            app.on(Ev.touchup, touchup);
            app.on(Ev.touchdown, touchdown);
            app.on(Ev.touchmove, touchmove);

                //create the debug renderer and view
            batcher = new Batcher( app.renderer, 'debug_batcher', Math.floor(Math.pow(2, 20)));
            batcher.show_stats = 0;
            
                //create a camera
            view = new Camera({ camera_name:'debug_batcher_camera' });
                //set the camera of the batcher
            batcher.view = view;
                //Also, set the layer so it renders last
            batcher.layer = 999;

            overlay = new QuadGeometry({
                id: 'debug.overlay',
                x:0, y:0,
                w: app.screen.w,  h: app.screen.h,
                color : new Color(0,0,0,0.8),
                depth : 999,    //debug depth
                visible : false, //default invisible
                batcher : batcher
            });

            overlay.locked = true;

                //create the scene inspector
            padding = new Vector(app.screen.w*0.05,app.screen.h*0.05);
            inspector = new Inspector({
                pos : new Vector(padding.x, padding.y),
                size : new Vector(app.screen.w-(padding.x*2), app.screen.h-(padding.y*2)),
                batcher : batcher
            });


            inspector.onrefresh = refresh;

            app.on(Ev.windowsized, function( _event:luxe.Screen.WindowEvent ){

                var _w = _event.x;
                var _h = _event.y;

                padding.set_xy(_w*0.05,_h*0.05);

                overlay.resize_xy(_w, _h);
                view.viewport = new Rectangle(0, 0, _w, _h);
                inspector.size = new Vector(_w-(padding.x*2), _h-(padding.y*2));
                inspector.pos = new Vector(padding.x, padding.y);

                for(view in views) {
                    view.onwindowsized(_event);
                }
            });

            for(view in views) {
                view.create();
            }

        #end //no_debug_console

    }

    static var debug_batch_tag  = 'batcher.debug_batcher';
    function render() {

        #if !no_debug_console

            if(visible) {

                #if !luxe_noprofile start(debug_batch_tag); #end

                    batcher.draw();

                #if !luxe_noprofile end(debug_batch_tag); #end

            }

        #end

    }

//Trace capturing

    public static var trace_callbacks : Array<Dynamic->?haxe.PosInfos->Void> = [];

    static var shut_down : Bool = false;
    static var tracing : Bool = false;

    static function internal_trace(_value:Dynamic, ?_info:haxe.PosInfos) {

        assert(tracing == false, 'luxe.Debug: calling trace from a trace callback is an infinite loop!');
        tracing = true;

            var _out = '$_value';

            if(_info != null && _info.customParams != null) {
                _out += ' ' + _info.customParams.join(' ');
            }

            #if cpp 
                untyped __trace(_out, _info);
            #elseif luxe_web 
                untyped console.log('${_info.fileName}::${Std.string(_info.lineNumber).rpad(" ", 4)} $_out'); 
            #end

            if(!shut_down) {
                for(_callback in trace_callbacks) {
                    _callback(_value, _info);
                }
            }

        tracing = false;

    }

//Events

    function mouseup(e:MouseEvent) {
        if(visible) {
            for(view in views) {
                view.onmouseup(e);
            }
        }
    }

    function mousedown(e:MouseEvent) {
        if(visible) {
            for(view in views) {
                view.onmousedown(e);
            }
        }
    }

    function mousemove(e:MouseEvent) {
        if(visible) {
            for(view in views) {
                view.onmousemove(e);
            }
        }
    }

    function mousewheel(e:MouseEvent) {
        if(visible) {
            for(view in views) {
                view.onmousewheel(e);
            }
        }
    }

   function touchup(e:TouchEvent) {
        if(visible) {
            for(view in views) {
                view.ontouchup(e);
            }
        }
    }

    function touchdown(e:TouchEvent) {

        #if (!no_debug_console && mobile)

                //3 finger tap when console opens will switch tabs
            if(app.app.input.touch_count == 3) {
                if(visible) {
                    switch_view();
                }
            }

                //4 finger tap toggles console
            if(app.app.input.touch_count == 4) {
                visible = !visible;
            }

        #end //no_debug_console


        if(visible) {
            for(view in views) {
                view.ontouchdown(e);
            }
        }
    }

    function touchmove(e:TouchEvent) {
        if(visible) {
            for(view in views) {
                view.ontouchmove(e);
            }
        }
    }

    function keyup(e:KeyEvent) {

        if(visible) {
            for(view in views) {
                view.onkeyup(e);
            }
        }

        #if profiler
            #if luxe_native
                if(e.keycode == Key.key_p && profiling) {
                    cpp.vm.Profiler.stop();
                    profiling = false;
                    trace("profiling complete. Look for the results in " + profile_path );
                }
            #end //luxe_native
        #end //profiler

    }

    function keydown(e:KeyEvent) {

        if(e.scancode == Scan.grave) {
            visible = !visible;
        }

        if(visible) {

            if(e.keycode == Key.key_1 && visible) {
                switch_view();
            }

            for(view in views) {
                view.onkeydown(e);
            }

        }

        #if profiler
            #if luxe_native
                if(e.keycode == Key.key_p && e.mod.ctrl && !e.repeat) {
                    trace("starting profiler ... let go of key to stop profiling.");
                    cpp.vm.Profiler.start( profile_path );
                    profiling = true;
                }
            #end //luxe_native
        #end //profiler

    }

    function refresh() {

        if(current_view != null) {
            current_view.refresh();
        }

    }

        /** programmatically switch the debug console view. currently cycles the view. */
    @:noCompletion public function switch_view() {

            //keep knowledge of this
        last_view_index = current_view_index;
            //then go up one, :todo : make easier to jump to specific view?
        current_view_index++;

            //handle looping
        if(current_view_index > views.length-1) {
            current_view_index = 0;
        }

            //now hide the last view
        views[last_view_index].hide();
            //store the new one
        current_view = views[current_view_index];

            //show the new one
        current_view.show();

    }

    var last_cursor_grab : Bool = false;

    function set_visible(_value:Bool) {

        #if no_debug_console
            return visible = false;
        #end

        visible = _value;
        overlay.visible = visible;

        if(visible) {

                //revert cursor grab
            last_cursor_grab = app.screen.cursor.grab;
            app.screen.cursor.grab = false;
                //show views
            current_view.show();
            inspector.show();

        } else {

            if(last_cursor_grab != false) {
                app.screen.cursor.grab = last_cursor_grab;
            }

            current_view.hide();
            inspector.hide();

        }

        return visible;

    }

    function destroy() {

        app.off(Ev.keyup, keyup);
        app.off(Ev.keydown, keydown);
        app.off(Ev.mouseup, mouseup);
        app.off(Ev.mousedown, mousedown);
        app.off(Ev.mousemove, mousemove);
        app.off(Ev.mousewheel, mousewheel);

        _debug('\t debug shut down.');
        shut_down = true;

    }

    function process() {

        dt_average_accum += app.frame_delta;
        dt_average_count++;

        if(dt_average_count == dt_average_span - 1) {
            dt_average = dt_average_accum/dt_average_span;
            dt_average_accum = dt_average;
            dt_average_count = 0;
        }

        if(!visible) {
            return;
        }

            //update the title
        inspector.title.text = '[${current_view.name}] / ${Math.round(1/dt_average)} / ${Maths.fixed(app.frame_delta,5)} / ${Maths.fixed(dt_average,5)}';

        for(view in views) {
            view.process();
        }

    }

}

