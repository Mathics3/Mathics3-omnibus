|Pypi Installs| |Latest Version| |Supported Python Versions|

Mathics3 is a general-purpose computer algebra system (CAS). It is an open-source alternative to Mathematica. It is free, both in the sense of "freedom" and in the sense of "free beer".

`Mathics3 <https://mathics.org>`_ consists of several separable components so that those pieces that are desired can be used without the burden of dependencies of the other parts.

For example, if you are interested in just running a command-line interface, you might not be interested in having Django and what that entails, and vice versa.
If you are just interested in the computational library, there is no need for either the Web parts or the command-line library parts.

But what if you want both the command-line interface, the Web interface, all of the Mathics3 Modules, and whatever else there is to offer?

That's what this repository is about. Here we have a PyPI installable package that pulls in the various components and offers commands:

* ``mathics3-code-tokenize`` utility to show how an input stream is tokenized by Mathics3, similar to ``CodeParser`CodeTokenize``.
* ``mathics3-code-parse`` utility to show how an input stream is tokenized by Mathics3, similar to ``CodeParser`CodeParse``.
* ``mathics3script`` to run the command-line interface,
* ``mathics3server`` to run the Django-Web server,
* ``dmathics3script`` and ``dmathicsserver``, which runs the docker version of these,
* ``dmathics3doc`` which runs a PDF viewer, `evince <https://wiki.gnome.org/Apps/Evince>`_, which can view the generated reference manual in PDF.
* ``dmathics3doccopy`` which copies the generated reference PDF manual out of the container and into the host filesystem.

This repository also contains the Dockerfiles used to create the `mathicsorg/mathics docker images <https://hub.docker.com/repository/docker/mathicsorg/mathics>`_.

That image is a combination of:

* `Mathics3-scanner <https://github.com/Mathics3/Mathics3-scanner>`_ (WL Character Tables and Mathics Scanner)
* `mathicsscript <https://github.com/Mathics3/mathicsscript>`_ (Command-line Mathics Interface)
* `mathics-pygments <https://github.com/Mathics3/mathics-pygments>`_ (WL Syntax Highlighting)
* `Mathics3-django <https://github.com/Mathics3/Mathics3-django>`_ (Django-based HTTP server)
* `mathics-threejs-backend <https://github.com/Mathics3/mathics-threejs-backend>`_ (Graphics3D rendering using threejs)
* `Mathics3-Module-nltk <https://github.com/Mathics3/Mathics3-Module-nltk>`_ (Mathics3 Module for Natural Language Processing add-on via NLTK).
* `Mathics3-Module-PyUI <https://github.com/Mathics3/Mathics3-Module-PyUCI>`_ (Mathics3 Module for ICU - Human-Language Alphabets and Locales via PyICU).
* `Mathics3-Module-networkx <https://github.com/Mathics3/Mathics3-Module-networkx>`_ (Graph add-on based on `NetworkX <https://networkx.org/>`_).

It is likely that in the future more components will be added, so stay tuned...

.. |Packaging status| image:: https://repology.org/badge/vertical-allrepos/Mathics-omnibus.svg
			    :target: https://repology.org/project/Mathics-omnibus/versions
.. |Latest Version| image:: https://badge.fury.io/py/Mathics-omnibus.svg
		 :target: https://badge.fury.io/py/Mathics-omnibus
.. |Pypi Installs| image:: https://pepy.tech/badge/Mathics-omnibus
.. |Supported Python Versions| image:: https://img.shields.io/pypi/pyversions/Mathics-omnibus.svg

Installing
----------

From pre-built artificats:
++++++++++++++++++++++++++

The easier ways to install are to use Python ``pip`` and ``docker``

To install from Python ``pip``::

  pip install Mathics3-omnibus

To install the Docker image, run::

  docker pull mathicsorg/mathics

See `<https://hub.docker.com/r/mathicsorg/mathics>`_ for more information on how to use it after installing

From GitHub:
++++++++++++

Beware that there is always a bit of churn in the code base. So what is in GitHub in the master right branch might not line up with all the changes across all the repositories.

Either before a release or right after a release, things generally match up, though.

I won't repeat how to install Python in developer mode, build a Python package, or create a Docker image. For that, use whatever generic help mechanism you use for helping with these generic kinds of tasks.

However, Python PIP, ``pyproject.toml`` is an important file to consult. And for Docker, the file is ``docker/Dockerfile``.


Docker-specific items
---------------------

By default, we use a SQLite database that has examples that you can
load and use. This data comes from
`mathics-omnibus/django-db/mathics.sqlite <https://github.com/Mathics3/mathics-omnibus/tree/master/docker/django-db>`_.

Since this is tied to the Docker image, any changes made won't survive
across restarting the Docker image.

If you would like to save your own, you can set the environment
variable ``MATHICS_DJANGO_DB_PATH``. Here is an example:


.. codeblock:: bash

   $ MATHICS_DJANGO_DB_PATH=/home/ubunutu/.local/var/Mathics3/mathics.sqlite
   MATHICS_DJANGO_DB_PATH=/home/ubunutu/.local/var/Mathics3/mathics.sqlite^J-(../mathics-omnibus/script/dmathicsserver:5):  -[2,0, 0]
   DOCKER=docker
   -(../mathics-omnibus/script/dmathicsserver:6):  -[2,0, 0]
   MATHICS_DJANGO_DB=mathics.sqlite
   -(../mathics-omnibus/script/dmathicsserver:7):  -[2,0, 0]
   MATHICS_DJANGO_DB_PATH=/home/ubunutu/.local/var/Mathics3/mathics.sqlite
   -(../mathics-omnibus/script/dmathicsserver:9):  -[2,0, 0]
   docker run -it --name mathics-web --rm --env=DISPLAY --env MATHICS_DJANGO_DB_PATH=/home/ubunutu/.local/var/Mathics3/mathics.sqlite --workdir=/app --volume=/src/external-vcs/github/Mathics3/mathics-django:/app --volume=/tmp/.X11-unix:/tmp/.X11-unix:rw -p 8000:8000 -v /tmp:/usr/src/app/data mathicsorg/mathics --mode ui

   ~~~~ app/data has been mounted to /usr/src/app/data ~~~~
   ~~~~ SQLite data (worksheets, user info) will be stored in /usr/src/app/data/mathics django/mathics.sqlite ~~~~
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    warning: database file /home/ubuntu/.local/var/Mathics3/mathics.sqlite not found

    Migrating database /home/ubuntu/.local/var/Mathics3/mathics.sqlite
    Operations to perform:
      Apply all migrations: auth, contenttypes, sessions, sites, web
    Running migrations:

In the above, when it says ``mathics.sqlite not found`` an empty one is
created. The real location of it outside of the container is in
``/tmp/mathics-django/mathics.sqlite``.
