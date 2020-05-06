# deb/rpm packaging using FPM in Docker

deb/rpm packages are a great way to deliver software for on-premise deployments. Building them is a massive pain in the ass, though.

[FPM](https://fpm.readthedocs.io/en/latest/intro.html) is a great wrapper for deb/rpm build tools, but installing it and all the dependencies needed to build fully functional deb/rpm packages on a developer workstation is tedious. We can do better: Let's run it in Docker.

[EclecticIQ](https://github.com/eclecticiq) have made a Docker image which contains FPM and all its dependencies: `eclecticiq/package` - [source code is available on Github](https://github.com/eclecticiq/package.docker).

It's not uncommon to build and run your application in Docker these days, and we can utilize buildkit + multi-stage builds to make the whole process super simple.


## The application

On this branch, we're writing a simple Python CLI application. We create a virtualenv in the build stage, and copy that virtualenv into both our packaging and production stages.

Our dummy application has one dependency, `psycopg2`, just to prove how you can add dependencies for packaging and multiple versions of Python.


## Scripts

`build.sh` will build or download wheels of the application itself, copy the wheels into a packaging image and then build the packages by invoking `fpm.sh` inside the Docker build process.

`run.sh` will jus run the application in Docker. No packaging involved here (though we do re-use the build logic as well as the method of installing the virtualenv with dependencies), just checking that the application itself works.

`test.sh` will run Debian and CentOS Docker images, install the packages that have been built, and check that the application works as expected.
