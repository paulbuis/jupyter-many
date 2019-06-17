# paulbuis/jupyter-many

Docker files for a docker image which is based on paulbuis/jupyter-beakerx-jupyter.
It adds:
	* xeus-cling kernel (conda install xeus-cling)
        * a handful of NPM packages (for use with ijavascript and itypescript)
	* ijavascript kernel (conda install ijavascript)
        * itypescript kernel (conda install itypescript)
It replaces the beakerx java kernel with this one:
        * iJava kernel (binary realease fromm https://github.com/SpencerPark/IJava)

### How to run it

1. Use docker command to run it
    `docker run --rm -p 8888:8888 paulbuis/jupyter-many`

### License

MIT
