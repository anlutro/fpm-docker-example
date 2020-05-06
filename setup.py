import setuptools

setuptools.setup(
    name="fpm-docker-example",
    packages=["hello"],
    install_requires=["psycopg2-binary"],
    entry_points={"console_scripts": ["hello-world=hello:main"]},
)
