
import luxe.Vector;
import luxe.Input;
import luxe.Entity;
import luxe.Component;


import luxe.Color;

class FakeRigidBody extends Component {


    override function init() {
        trace('init rigidbody');
    }

    override function onreset() {
        trace('reset rigidbody');
        trace('getting collider' + entity.get('collider'));
    }

    override function ondestroy() {
        trace('destroy rigidbody');
    }


}


class FakeMeshComponent extends Component {


    override function init() {
        trace('init FakeMeshComponent');

    }

    override function onreset() {
        trace('reset FakeMeshComponent');
    }

    override function ondestroy() {
        trace('destroy FakeMeshComponent');
    }


}

class FakeCollider extends Component {


    override function init() {
        trace('init FakeCollider');
    }

    override function onreset() {
        trace('reset FakeCollider');
    }

    override function ondestroy() {
        trace('destroy FakeCollider');
    }


}

class Main extends luxe.Game {


    var root : Entity;
    var child : Entity;
    var child_of_child : Entity;

    var spherething : Entity;
    var spherechild : Entity;

    var od : Bool = true;


    override function ready() {

        root = new Entity();
        root.transform.world.auto_decompose = true;
        root.pos = new Vector(10,10,10);

        child = new Entity();
        child.transform.world.auto_decompose = true;
        child_of_child = new Entity();
        child_of_child.transform.world.auto_decompose = true;

        child_of_child.parent = child;
        child.parent = root;

        child.pos = new Vector(10,10,10);
        child_of_child.pos = new Vector(50,0,10);

        spherething = new Entity();
        spherething.name = 'sphere';
        spherechild = new Entity();
        spherechild.name = 'childmesh';

        spherechild.parent = spherething;

            //physics on the parent
        spherething.add( new FakeRigidBody({ name:'rigidbody' }) );
        spherething.add( new FakeCollider({ name:'collider' }) );

            //add the mesh to the child
        spherechild.add( new FakeMeshComponent({ name:'mesh' }) );

            //test that get works, it should print the type names of all
        trace( spherething.get('collider') );
        trace( spherething.get('mesh', true) );
        trace( spherething.get('mesh') );
        trace( spherething.get('rigidbody') );

            //test
        spherething.destroy();

    }

    function draw_entities_transforms() {

        Luxe.draw.rectangle({
            x : root.transform.world.pos.x - 2, y : root.transform.world.pos.y - 2,
            w : 4, h : 4,
            color : new Color(0.2,0.6,1),
            immediate : true
        });

        Luxe.draw.rectangle({
            x : child.transform.world.pos.x - 2, y : child.transform.world.pos.y - 2,
            w : 4, h : 4,
            color : new Color(1,0.6,0.2),
            immediate : true
        });

        Luxe.draw.rectangle({
            x : child_of_child.transform.world.pos.x - 2, y : child_of_child.transform.world.pos.y - 2,
            w : 4, h : 4,
            color : new Color(0.6,1,0.2),
            immediate : true
        });

    }

    override function onmousemove( e:MouseEvent ) {

        if(od) {
            root.pos = e.pos;
        } else {
            child.pos = e.pos;
        }

    }

    override function onkeyup( e:KeyEvent ) {

        if(e.keycode == Key.key_r) {

            child.pos = new Vector(10,10,10);
            child_of_child.pos = new Vector(50,0,10);

        } //R key

        if(e.keycode == Key.key_p) {

            if(child.parent != null) {
                child.parent = null;
                trace('no parent');
            } else {
                child.parent = root;
                trace('parent');
            }

            trace('absolute: ' + child.transform.world.pos);
            trace('relative: ' + child.pos);

        }

        if(e.keycode == Key.space) {
            od = !od;
        }

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    }

    override function update(dt:Float) {
        draw_entities_transforms();
    }



}
