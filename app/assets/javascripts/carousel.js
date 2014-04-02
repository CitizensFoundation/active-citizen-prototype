// From http://www.mingoland.co.uk/webgl/carousel/

/* -- Carousel -- */
var Carousel = function (rad, images, w, h, scene) {
    THREE.Object3D.call(this);
    this.images = images;
    this.rad = rad;
    this.howMany = 0;
    this.reflectionOpacity = 0.1;
    this.reflectionHeightPer = 0.5;
    this.imgs = [];
    this.page_urls = [];
    var thiss = this;
    this.w = w;
    this.h = h;
    for (var i = 0; i < this.images.length; i++) {
        this.imgs[i] = new Image();
        this.page_urls[i] = this.images[i].page_url;
        if (i==this.images.length-1) {
            this.imgs[i].onload = function () {
                thiss.buildCarousel(thiss,true);
            };

        } else {
            this.imgs[i].onload = function () {
                thiss.buildCarousel(thiss,false);
            };
        }
        this.imgs[i].src = this.images[i].url;
    }
    this.anglePer = 2 * Math.PI / this.images.length;
    scene.add(this);
}

done = false;

// Carousel is subclass of Object3D
Carousel.prototype = new THREE.Object3D;
Carousel.prototype.constructor = Carousel;
Carousel.prototype.buildCarousel = function (scope,setDone) {
    scope.howMany++;
    if (scope.howMany == scope.images.length) {
        for (var i = 0; i < scope.images.length; i++) {
            // image plane
            var texture = new THREE.Texture(scope.imgs[i]);
            var plane = new THREE.Mesh(new THREE.PlaneGeometry(scope.w, scope.h, 3, 3), new THREE.MeshBasicMaterial({ map: texture, overdraw: true }));
            var aa = i * scope.anglePer;
            plane.rotation.y = -aa - Math.PI / 2;
            plane.position = new THREE.Vector3(scope.rad * Math.cos(aa), 0, scope.rad * Math.sin(aa));
            plane.doubleSided = true;
            plane.carouselAngle = aa;//plane.rotation.y;
            plane.scale.x = -1;
            plane.material.side = THREE.DoubleSide;
            plane["page_url"] = scope.images[i].page_url;
            plane["page_id"] = i;
            this.add(plane);
            //this.add(reflectionplane);

            if (i == 0) {
                plane.rotation.y = 0;
                plane.position = new THREE.Vector3(1, 1324, 1);
                plane.doubleSided = true;
                plane.carouselAngle = 0;//plane.rotation.y;
                plane.scale.x = 3;
                plane.scale.y = 3;

                main_idea_plane = plane;
            }
        }
    }
    if (setDone) { done = true; }
};

function createFloor() {
    // Grid
    var size = 6000, step = 500;
    var y = -440.0;

    var geometry = new THREE.Geometry();

    colors = [], colors2 = [], colors3 = [];

    for ( i = 0; i < 5; i ++ ) {
        colors[ i ] = new THREE.Color( 0xffffff );
        colors[ i ].setHSL( 0.6, 1.0, Math.max( 0, ( 200 - 5 ) / 400 ) * 0.5 + 0.5 );

        colors2[ i ] = new THREE.Color( 0xffffff );
        colors2[ i ].setHSL( 0.3, 1.0, Math.max( 0, ( 200 + 6 ) / 400 ) * 0.5 );

        colors3[ i ] = new THREE.Color( 0xffffff );
        colors3[ i ].setHSL( i / 5, 1.0, 0.5 );

    }

    var material = new THREE.LineBasicMaterial( { color: 0xbbbbbb, opacity: 1, linewidth: 2.2} );

    for ( var i = - size; i <= size; i += step ) {

        geometry.vertices.push( new THREE.Vector3( - size, y, i ) );
        geometry.vertices.push( new THREE.Vector3(   size, y, i ) );

        geometry.vertices.push( new THREE.Vector3( i, y, - size ) );
        geometry.vertices.push( new THREE.Vector3( i, y,   size ) );

    }

    var line = new THREE.Line( geometry, material, THREE.LinePieces );
    scene.add( line );
}

shifted=false;
alted=false;

$(document).bind('keyup keydown', function(e){ shifted = e.shiftKey; ctrled = e.altKey } );

$("body").keypress(function(e){
    if (e.which==13) {
        if (shifted==true) {
            if (current_id == 0) {
                current_id = carousel.children.length-1;
                rotateCarousel(carousel.children[current_id], false);
            } else {
                rotateCarousel(carousel.children[current_id -= 1], false);
            }
        } else if (alted==true) {
          $.colorbox({href: carousel.children[current_id].page_url, iframe: true, opacity: 1.0, open: true, innerHeight: "85%", innerWidth: "85%" });
        } else {
            if (current_id >= carousel.children.length-1) {
                current_id = 0;
                rotateCarousel(carousel.children[current_id], false);
            } else {
                rotateCarousel(carousel.children[current_id += 1], false);
            }
        };
    };
});

// Bg gradient
var canvas = document.createElement('canvas');
canvas.width = 32;
canvas.height = window.innerHeight;
var context = canvas.getContext('2d');
var gradient = context.createLinearGradient(0, 0, 0, canvas.height);
gradient.addColorStop(0, "#FFFFFF");
gradient.addColorStop(0.5, "#FFFFFF");
gradient.addColorStop(0.82, "#DDDDDD");
gradient.addColorStop(1, "#AAAAAA");
context.fillStyle = gradient;
context.fillRect(0, 0, canvas.width, canvas.height);
document.body.style.background = 'url(' + canvas.toDataURL('image/png') + ')';

var container;
var camera, scene, renderer, projector;
var updatecamera = false, carouselupdate = true;
var carousel;

var have_set_first_item=false;

var targetRotationY = 0;
var targetRotationOnMouseDownY = 0;
var targetRotationX = 0;
var targetRotationOnMouseDownX = 0;

var mouse = {x: 0, y: 0}, prevmouse = {x: 0, y: 0};
var mouseX = 0;
var mouseXOnMouseDown = 0;
var mouseY = 0;
var mouseYOnMouseDown = 0;
var windowHalfX = window.innerWidth / 2;
var windowHalfY = window.innerHeight / 2;

/****** INIT *****/

container = document.getElementById('container');
var w, h;
//			var	w=2640, h=1440-4;
w = window.innerWidth;
h = window.innerHeight;
container.style.width = w + "px";
container.style.height = h + "px";
container.style.marginTop = 0.5 * (window.innerHeight - h) + 'px';

scene = new THREE.Scene();

camera = new THREE.PerspectiveCamera(70, w / h, 1, 50000);
camera.position.x = 0;
camera.position.y = -50;
camera.position.z = 420;

scene.add(camera);

var main_idea_plane;


initLoader(scene,camera);

// Carousel
carousel = new Carousel(2570, images, 1366, 768, scene);

projector = new THREE.Projector();
renderer = new THREE.CanvasRenderer();
renderer.setSize(w, h);
renderer.setClearColor( 0xffffff, 1 );
container.appendChild(renderer.domElement);

container.addEventListener('dblclick', ondblClick, false);
container.addEventListener('mousedown', onDocumentMouseDown, false);
container.addEventListener('touchstart', onDocumentTouchStart, false);
container.addEventListener('touchmove', onDocumentTouchMove, false);

var start_rotation = { x: 0, y: 0.0, z: 0.0 };
var target_rotation = { x: 0, y: 6.30, z: 0.0 };
var main_idea_tween = new TWEEN.Tween(start_rotation).to(target_rotation, 270000);

main_idea_tween.onUpdate(function () {
    main_idea_plane.rotation.y = start_rotation.y;
});

main_idea_tween.delay(1200);
main_idea_tween.start();

var current_id = 0;

createFloor();

/****** INIT *****/

animate();


function rotateCarousel(item, easing) {
    carouselupdate = false;
    var angle = (item.carouselAngle - Math.PI / 2) % (2 * Math.PI);
    var b = carousel.rotation.y % (2 * Math.PI);
    var ang;
    if (b > 0) b = -2 * Math.PI + b;
    carousel.rotation.y = b;
    if (angle < b) angle += 2 * Math.PI;
    if ((angle - b) > 2 * Math.PI - (angle - b)) {
        ang = b + (-(2 * Math.PI - (angle - b)));
    }
    else {
        ang = b + (angle - b);
    }

    if (easing) {
        new TWEEN.Tween(carousel.rotation).to({y: ang}, 800).easing(TWEEN.Easing.Exponential.EaseInOut).onComplete(function () {
            carouselupdate = true;
            targetRotationY = carousel.rotation.y;
        }).start();
    } else {
        new TWEEN.Tween(carousel.rotation).to({y: ang}, 100).easing(TWEEN.Easing.Exponential.EaseInOut).onComplete(function () {
            carouselupdate = true;
            targetRotationY = carousel.rotation.y;
        }).start();
    }
}

function findPage(page_id) {

}

function ondblClick(event) {
    event.preventDefault();
    dblclick = true;

    mouse.x = ( event.clientX / window.innerWidth ) * 2 - 1;
    mouse.y = -( event.clientY / window.innerHeight ) * 2 + 1;
    var vector = new THREE.Vector3(mouse.x, mouse.y, 1);
    projector.unprojectVector(vector, camera);

    var ray = new THREE.Raycaster(camera.position, vector.sub(camera.position).normalize());

    var intersects = ray.intersectObjects(carousel.children);

    if (intersects.length > 0) {
        if (current_page(intersects[0].object)) {
            //alert(carousel.children[current_id].page_url);
            //window.open(carousel.children[current_id].page_url, '_blank');
            $.colorbox({href: carousel.children[current_id].page_url, iframe: true, opacity: 1.0, open: true, innerHeight: "85%", innerWidth: "85%" });

        } else {
            rotateCarousel(intersects[0].object, true);
            setCurrentetChildId(intersects[0].object);
        }
    }
}

function onDocumentMouseDown(event) {

    event.preventDefault();

    container.addEventListener('mousemove', onDocumentMouseMove, false);
    container.addEventListener('mouseup', onDocumentMouseUp, false);
    container.addEventListener('mouseout', onDocumentMouseOut, false);

    mouse.x = ( event.clientX / window.innerWidth ) * 2 - 1;
    mouse.y = -( event.clientY / window.innerHeight ) * 2 + 1;
    prevmouse = {x: mouse.x, y: mouse.y};
    mouseXOnMouseDown = event.clientX - windowHalfX;
    mouseYOnMouseDown = event.clientY - windowHalfY;
    targetRotationOnMouseDownY = targetRotationY;
    targetRotationOnMouseDownX = targetRotationX;
}

function onDocumentMouseMove(event) {

    mouseX = event.clientX - windowHalfX;
    mouseY = event.clientY - windowHalfY;
    mouse.x = ( event.clientX / window.innerWidth ) * 2 - 1;
    mouse.y = -( event.clientY / window.innerHeight ) * 2 + 1;

    targetRotationY = targetRotationOnMouseDownY + ( mouseX - mouseXOnMouseDown ) * 0.002;
    targetRotationX = targetRotationOnMouseDownX + ( mouseY - mouseYOnMouseDown ) * 0.002;

    if (camera.position.z < 430) {
        //  camera.position.z = 430
    }
    if (camera.position.z > 600) {
        //  camera.position.z = 600
    }
    updatecamera = true;
}

function onDocumentMouseUp(event) {

    container.removeEventListener('mousemove', onDocumentMouseMove, false);
    container.removeEventListener('mouseup', onDocumentMouseUp, false);
    container.removeEventListener('mouseout', onDocumentMouseOut, false);
}

function onDocumentMouseOut(event) {

    container.removeEventListener('mousemove', onDocumentMouseMove, false);
    container.removeEventListener('mouseup', onDocumentMouseUp, false);
    container.removeEventListener('mouseout', onDocumentMouseOut, false);
}

function onDocumentTouchStart(event) {

    if (event.touches.length == 1) {

        event.preventDefault();

        mouse.x = ( event.touches[ 0 ].pageX / window.innerWidth ) * 2 - 1;
        mouse.y = -( event.touches[ 0 ].pageY / window.innerHeight ) * 2 + 1;
        prevmouse = {x: mouse.x, y: mouse.y};
        mouseXOnMouseDown = event.clientX - windowHalfX;
        mouseYOnMouseDown = event.clientY - windowHalfY;
        targetRotationOnMouseDownY = targetRotationY;
        targetRotationOnMouseDownX = targetRotationX;

    }
}

function onDocumentTouchMove(event) {

    if (event.touches.length == 1) {

        event.preventDefault();

        mouse.x = ( event.touches[ 0 ].pageX / window.innerWidth ) * 2 - 1;
        mouse.y = -( event.touches[ 0 ].pageY / window.innerHeight ) * 2 + 1;
        prevmouse = {x: mouse.x, y: mouse.y};
        mouseXOnMouseDown = event.clientX - windowHalfX;
        mouseYOnMouseDown = event.clientY - windowHalfY;
        targetRotationOnMouseDownY = targetRotationY;
        targetRotationOnMouseDownX = targetRotationX;
//				updatecamera=true;
    }
}

function animate() {
    requestAnimationFrame(animate);
    render();
}

function setCurrentetChildId(object) {
    for (i = 0; i < carousel.children.length; i++) {
        if (carousel.children[i] == object) {
            current_id = i;
        }
    }
}

function current_page(object) {
    found = false;
    if (carousel.children[current_id] == object) {
        found = true;
    }
    return found;
}


function render() {
    if (carouselupdate)
        carousel.rotation.y += ( targetRotationY - carousel.rotation.y ) * 0.05;
    if (updatecamera && Math.abs(mouse.y - prevmouse.y) > Math.abs(mouse.x - prevmouse.x))
        camera.position.z += (mouse.y - prevmouse.y) * 20;

    if (!done) {
        render_loader();
    } else if (have_set_first_item==false) {
        //rotateCarousel(carousel.children[0], true);
        var target_position = { x: 0, y: -120, z: 3400 };
        var start_position = { x: 0, y: -50, z: 420 };
        var camera_tween = new TWEEN.Tween(start_position).to(target_position, 900);

        camera_tween.onUpdate(function () {
            camera.position.set(start_position.x, start_position.y, start_position.z);
        });

        camera_tween.delay(600);
        camera_tween.start();
        have_set_first_item = true;
    };

    renderer.render(scene, camera);
    updatecamera = true;
//				carouselupdate=true;
    TWEEN.update();
}
