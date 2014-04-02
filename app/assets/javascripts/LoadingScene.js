//if (!Detector.webgl) Detector.addGetWebGLMessage();

var effectFXAA;

var mouseX = 0, mouseY = 0,

    windowHalfX = window.innerWidth / 2,
    windowHalfY = window.innerHeight / 2,

    loader_scene, loader_renderer, loader_material, loader_composer;

function initLoader(scene,camera) {

    var i, container;
    loader_scene = scene;

    var geometry = new THREE.Geometry(),
        geometry2 = new THREE.Geometry(),
        geometry3 = new THREE.Geometry(),
        points = hilbert3D(new THREE.Vector3(0, 0, 0), 200.0, 2, 0, 1, 2, 3, 4, 5, 6, 7),
        colors = [], colors2 = [], colors3 = [];

    for (i = 0; i < points.length; i++) {

        geometry.vertices.push(points[ i ]);

        colors[ i ] = new THREE.Color(0xffffff);
        colors[ i ].setHSL(0.6, 1.0, Math.max(0, ( 200 - points[ i ].x ) / 400) * 0.5 + 0.5);

        colors2[ i ] = new THREE.Color(0xffffff);
        colors2[ i ].setHSL(0.3, 1.0, Math.max(0, ( 200 + points[ i ].x ) / 400) * 0.5);

        colors3[ i ] = new THREE.Color(0xffffff);
        colors3[ i ].setHSL(i / points.length, 1.0, 0.5);

    }

    geometry2.vertices = geometry3.vertices = geometry.vertices;

    geometry.colors = colors;
    geometry2.colors = colors2;
    geometry3.colors = colors3;

    // lines

    loader_material = new THREE.LineBasicMaterial({ color: 0xffffff, opacity: 1, linewidth: 3, vertexColors: THREE.VertexColors });

    var line, p, scale = 0.3, d = 225;
    var parameters = [
        [ loader_material, scale * 1.5, [-d, 0, 0], geometry ],
        [ loader_material, scale * 1.5, [0, 0, 0], geometry2 ],
        [ loader_material, scale * 1.5, [d, 0, 0], geometry3 ]
    ];

    for (i = 0; i < parameters.length; ++i) {

        p = parameters[ i ];
        line = new THREE.Line(p[ 3 ], p[ 0 ]);
        line.scale.x = line.scale.y = line.scale.z = p[ 1 ];
        line.position.x = p[ 2 ][ 0 ];
        line.position.y = p[ 2 ][ 1 ];
        line.position.z = p[ 2 ][ 2 ];
        scene.add(line);

    }

    var renderModel = new THREE.RenderPass(scene, camera);
    var effectBloom = new THREE.BloomPass(1.3);
    var effectCopy = new THREE.ShaderPass(THREE.CopyShader);

    effectFXAA = new THREE.ShaderPass(THREE.FXAAShader);

    var width = window.innerWidth || 2;
    var height = window.innerHeight || 2;

    effectFXAA.uniforms[ 'resolution' ].value.set(1 / width, 1 / height);

    effectCopy.renderToScreen = true;

    loader_composer = new THREE.EffectComposer(loader_renderer);

    loader_composer.addPass(renderModel);
    loader_composer.addPass(effectFXAA);
    loader_composer.addPass(effectBloom);
    loader_composer.addPass(effectCopy);
}


// port of Processing Java code by Thomas Diewald
// http://www.openprocessing.org/visuals/?visualID=15599

function hilbert3D(center, side, iterations, v0, v1, v2, v3, v4, v5, v6, v7) {

    var half = side / 2,

        vec_s = [

            new THREE.Vector3(center.x - half, center.y + half, center.z - half),
            new THREE.Vector3(center.x - half, center.y + half, center.z + half),
            new THREE.Vector3(center.x - half, center.y - half, center.z + half),
            new THREE.Vector3(center.x - half, center.y - half, center.z - half),
            new THREE.Vector3(center.x + half, center.y - half, center.z - half),
            new THREE.Vector3(center.x + half, center.y - half, center.z + half),
            new THREE.Vector3(center.x + half, center.y + half, center.z + half),
            new THREE.Vector3(center.x + half, center.y + half, center.z - half)

        ],

        vec = [ vec_s[ v0 ], vec_s[ v1 ], vec_s[ v2 ], vec_s[ v3 ], vec_s[ v4 ], vec_s[ v5 ], vec_s[ v6 ], vec_s[ v7 ] ];

    if (--iterations >= 0) {

        var tmp = [];

        Array.prototype.push.apply(tmp, hilbert3D(vec[ 0 ], half, iterations, v0, v3, v4, v7, v6, v5, v2, v1));
        Array.prototype.push.apply(tmp, hilbert3D(vec[ 1 ], half, iterations, v0, v7, v6, v1, v2, v5, v4, v3));
        Array.prototype.push.apply(tmp, hilbert3D(vec[ 2 ], half, iterations, v0, v7, v6, v1, v2, v5, v4, v3));
        Array.prototype.push.apply(tmp, hilbert3D(vec[ 3 ], half, iterations, v2, v3, v0, v1, v6, v7, v4, v5));
        Array.prototype.push.apply(tmp, hilbert3D(vec[ 4 ], half, iterations, v2, v3, v0, v1, v6, v7, v4, v5));
        Array.prototype.push.apply(tmp, hilbert3D(vec[ 5 ], half, iterations, v4, v3, v2, v5, v6, v1, v0, v7));
        Array.prototype.push.apply(tmp, hilbert3D(vec[ 6 ], half, iterations, v4, v3, v2, v5, v6, v1, v0, v7));
        Array.prototype.push.apply(tmp, hilbert3D(vec[ 7 ], half, iterations, v6, v5, v2, v1, v0, v3, v4, v7));

        return tmp;

    }

    return vec;
}


function render_loader() {
    var time = Date.now() * 0.0005;

    for (var i = 0; i < loader_scene.children.length; i++) {

        var object = loader_scene.children[ i ];
        if (object instanceof THREE.Line) object.rotation.y = time * ( i % 2 ? 1 : -1 );

    }

    //loader_renderer.clear();
   // if (loader_composer!=undefined) { loader_composer.render(); };
}
