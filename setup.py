import setuptools

setuptools.setup(
    name="hello-world",
    packages=["hello"],
    install_requires=["requests", "psycopg2-binary"],
    entry_points={"console_scripts": ["hello-world=hello:main"]},
)
