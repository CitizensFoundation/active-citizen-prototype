    function setupStarfield() {
        starfield = new THREE.Object3D();
        addCelestialObjectsTo(starfield, 670, createStar);
        addCelestialObjectsTo(starfield, 90, createRedDwarf);

        scene.add( starfield );
    }


    function createStar(ctx) {
        var gradient = ctx.createRadialGradient(8, 8, 0, 8, 8, 8);
        gradient.addColorStop(0,    'rgba(255,255,255,.8)' );
        gradient.addColorStop(0.2,  'rgba(0,128,128,.6)' );
        gradient.addColorStop(0.4,  'rgba(0,0,128,.6)' );
        gradient.addColorStop(0.6,  'rgba(0,0,64,.4)' );
        gradient.addColorStop(1,    'rgba(0,0,0,.2)' );

        ctx.fillStyle = gradient;
        ctx.fillRect(0, 0, 16, 16);
    }

    function createRedDwarf(ctx) {
        var gradient = ctx.createRadialGradient(8, 8, 0, 8, 8, 8);
        gradient.addColorStop(0,    'rgba(255,255,255,.8)' );
        gradient.addColorStop(0.2,  'rgba(128,128,0,.6)' );
        gradient.addColorStop(0.4,  'rgba(128,0,0,.6)' );
        gradient.addColorStop(0.6,  'rgba(64,0,0,.4)' );
        gradient.addColorStop(1,    'rgba(0,0,0,.2)' );

        ctx.fillStyle = gradient;
        ctx.fillRect(0, 0, 16, 16);
    }

    function addCelestialObjectsTo(group, max, func) {
        var celObj;
        var material = new THREE.ParticleCanvasMaterial({color: 0xffffff, program: func});

        for(var i=0; i < max; ++i) {
            celObj = new THREE.Particle(material);
            celObj.position.x = Math.random() * 3200 - 1000;
            celObj.position.y = Math.random() * 3200 - 1000;
            celObj.position.z = Math.random() * 3200 - 1000;
            celObj.scale.x = celObj.scale.y = Math.random() * 2;

            group.add(celObj);
        }
    }

