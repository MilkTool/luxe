package phoenix;

import phoenix.Texture;
import phoenix.Batcher;
import phoenix.geometry.Geometry;
import phoenix.geometry.GeometryState;

import nmegl.gl.GL;

class BatchState {

    public var state :  GeometryState;
    public var last_state : GeometryState;
    public var last_texture_id : Dynamic;
    public var last_group : Int;
    public var is_clipping : Bool;
    public var clip_rect : Dynamic;
    public var last_clip_rect : Dynamic;

    public function new(){
        state = new GeometryState();
        last_state = new GeometryState();
    }

    public function str() {
        trace('\t+ BATCHSTATE LAST ');
            trace("\t\tdepth - "+last_state.depth);
            trace("\t\tgroup - "+last_state.group);
            trace("\t\ttexture - " + (( last_state.texture == null) ? 'null' :  last_state.texture.id ));
            if(last_state.texture != null) {
                trace("\t\t\t " + last_state.texture.texture);
            }  
            trace("\t\tprimitive_type - "+last_state.primitive_type);
            trace("\t\tclip - "+last_state.clip);
        trace('\t- BATCHSTATE LAST');

        trace('\t+ BATCHSTATE STATE');
            trace("\t\tdepth - "+state.depth);
            trace("\t\tgroup - "+state.group);
            trace("\t\ttexture - " + (( state.texture == null) ? 'null' :  state.texture.id ));
            if(state.texture != null) {
                trace("\t\t\t " + state.texture.texture);
            }  
            trace("\t\tprimitive_type - "+state.primitive_type);
            trace("\t\tclip - "+state.clip);
        trace('\t- BATCHSTATE STATE');
    }

    public function activate(batcher:Batcher) {
        

            // Handle texture state changes 
        if(state.dirty) {
            trace("STATE DIRTY");
            if(state.texture != null) {

                if(!last_texture_id) {
                    GL.enable(GL.TEXTURE_2D);
                }

                trace('checking state of texture ; ');
                trace('was ' + last_texture_id + ' ' + state.texture.id);
                if(last_texture_id != state.texture.id){
                    last_texture_id = state.texture.id;                    
                    state.texture.bind();
                }

            } else {
                GL.disable(GL.TEXTURE_2D);
                last_texture_id = 0;
            }

            /*
                // Handle group state changes
            if(state.group != last_group) {
                // finalize the previous group.
                auto previous = r.getGroupState(last_group);
                if(previous) previous->end(r);

                // activate the current group.
                auto current = r.getGroupState(state.group);
                if(current) current->begin(r);

                last_group = state.group;
            }*/

        } //state.dirty

            // excluded from isDirty because rect can change every time without the state being dirty */
            // Handle clipping state changes 

            // if(state.getClip()){
            //     if( !is_clipping ){
            //         glEnable( GL_SCISSOR_TEST );
            //         is_clipping = true;
            //     }

            //     // update scissor test if needed.
            //     if(clip_rect != last_clip_rect){
            //         // translate from top-left coords to bottom-left cords
            //         GLint view[4];
            //         glGetIntegerv( GL_VIEWPORT, &view[0] );
            //         GLuint r_y = view[3] - ((GLuint)clip_rect.getX() + (GLuint)clip_rect.getHeight());

            //         glScissor( (GLuint)clip_rect.getX() , r_y, (GLsizei)clip_rect.getWidth(), (GLsizei)clip_rect.getHeight() );
            //     }
            // }
            // else{
            //     if( is_clipping ){
            //         glDisable( GL_SCISSOR_TEST );
            //         is_clipping = false;
            //     }
            // }

            // finally, mark the state as clean.
        state.clean();
    }

    public function deactivate(batcher:Batcher) {
        
        if(last_texture_id) {
            GL.disable(GL.TEXTURE_2D);
        }

        // finalize the previous group.
        // auto previous = r.getGroupState(last_group);
        // if(previous) previous->end(r);

        // remove clipping
        // if( is_clipping ) glDisable( GL_SCISSOR_TEST );
    }

    public function update( geom:Geometry ) : Bool {

        trace('updating state a ' + geom.state.dirty);
        trace('updating state b ' + state.dirty);
        last_state = state.clone();
        state.update(geom.state);

        str();

        //todo
        // if(state.clip){
        //     last_clip_rect = clip_rect;
        //     clip_rect = geom.cliprect;
        // }

        return state.dirty;// || last_clip_rect != clip_rect;        
    }

}