# deb/rpm packaging using FPM in Docker

deb/rpm packages are a great way to deliver software for on-premise deployments. Building them is a massive pain in the ass, though.

[FPM](https://fpm.readthedocs.io/en/latest/intro.html) is a great wrapper for deb/rpm build tools, but installing it and all the dependencies needed to build fully functional deb/rpm packages on a developer workstation is tedious. We can do better: Let's run it in Docker.

[EclecticIQ](https://github.com/eclecticiq) have made a Docker image which contains FPM and all its dependencies: `eclecticiq/package` - [source code is available on Github](https://github.com/eclecticiq/package.docker).

It's not uncommon to build and run your application in Docker these days, and we can utilize buildkit + multi-stage builds to make the whole process super simple.


## The application

In this example we're just using a hello world program written in Go, but the general concept is applicable to all programming languages.

For any compiled language, just make sure the binary and any required shared libraries are available. For Java you'll want to specify any JVM implementation as a dependency of your package.

For a scripted language, let's use Python as an example. You first want to define the python version as a dependency of your package, because you do need the runtime to be present. Then you just need to make sure that all the code + dependencies are available. The easiest way to do this is to create a virtualenv, install your app + dependencies into it, then include the whole virtualenv in the package itself. A good path for the virtualenv would be `/opt/myapp`.


## Scripts

`run.sh` will just compile and run the application in Docker. No packaging involved here, just checking that the application itself works.

`build.sh` will compile the application, copy the compiled application into a packaging image and then build the packages by invoking `fpm.sh` inside the Docker build process.

`test.sh` will run debian and centos Docker images, install the packages that have been built, and check that the application works as expected.
