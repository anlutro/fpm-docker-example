# deb/rpm packaging using FPM using Earthly

deb/rpm packages are a great way to deliver software for on-premise deployments. Building them is a massive pain in the ass, though.

[FPM](https://fpm.readthedocs.io/en/latest/intro.html) is a great wrapper for deb/rpm build tools, but installing it and all the dependencies needed to build fully functional deb/rpm packages on a developer workstation is tedious.

One solution is to run the build in containers. [EclecticIQ](https://github.com/eclecticiq) have made a Docker image which contains FPM and all its dependencies: `eclecticiq/package` - [source code is available on Github](https://github.com/eclecticiq/package.docker).
However, orchestrating building multiple images and copying files between stages and the local file system can get really annoying.

[Earthly](https://earthly.dev) is a great system using Docker under the hood to run make-like build commands in containers, which basically solves this whole problem.

To build packages, run `earthly +build-packages` - this will place Debian and RPM packages in the `dist` directory.


## The application

In this example we're just using a hello world program written in Go, but the general concept is applicable to all programming languages.

For any compiled language, just make sure the binary and any required shared libraries are available. For Java you'll want to specify any JVM implementation as a dependency of your package.

For a scripted language, let's use Python as an example. You first want to define the python version as a dependency of your package, because you do need the runtime to be present. Then you just need to make sure that all the code + dependencies are available. The easiest way to do this is to create a virtualenv, install your app + dependencies into it, then include the whole virtualenv in the package itself. A good path for the virtualenv would be `/opt/myapp`.
