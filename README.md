# deb/rpm packaging using FPM in Docker

deb/rpm packages are a great way to deliver software for on-premise deployments. Building them is a massive pain in the ass, though.

[FPM](https://fpm.readthedocs.io/en/latest/intro.html) is a great wrapper for deb/rpm build tools, but installing it and all the dependencies needed to build fully functional deb/rpm packages on a developer workstation is tedious. We can do better: Let's run it in Docker.

[EclecticIQ](https://github.com/eclecticiq) have made a Docker image which contains FPM and all its dependencies: `eclecticiq/package` - [source code is available on Github](https://github.com/eclecticiq/package.docker).

It's not uncommon to build and run your application in Docker these days, and we can utilize buildkit + multi-stage builds to make the whole process super simple.


## The application

On this branch, we're writing a simple Python CLI application. The end package will create a virtualenv with the application and its dependencies installed.

While it's possible to just create a virtualenv, install everything, and ship that as the package, this becomes difficult if you want to support more than one version of Python - you'll have to repeat the build stage for every Python version you want to support because you're likely to have binary dependencies that only work with one specific Python runtime.

Our alternate approach builds a wheel for the application and downloads wheels for dependencies, and installs these wheels when the package is installed.

Our dummy application has a few dependencies (`psycopg2` and `requests`) just to prove how you can add dependencies for packaging and multiple versions of Python.


## Scripts

`run.sh` will just run the application in Docker. No packaging involved here (though we do re-use the build logic as well as the method of installing the virtualenv with dependencies), just checking that the application itself works.

`build.sh` will use Docker to build the application and its packages, most of which steps can be traced in the Dockerfile. Some of them have been extracted into shell scripts for readability:

- `download-deps.sh` downloads wheels of packages that our application depends on for all supported versions of Python.
- `install-venv.sh` installs a virtualenv from the wheels built and downloaded in the earlier steps.
- `fpm.sh` runs FPM to build the actual deb/rpm packages.

`test.sh` will run Debian and CentOS Docker images, install the packages that have been built, and check that the application works as expected.
