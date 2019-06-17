# paulbuis/jupyter-many

Docker files for a docker image which is based on paulbuis/jupyter-beakerx.
It adds:
	* xeus-cling kernel (conda install xeus-cling)
        * a handful of NPM packages (for use with ijavascript and itypescript)
	* ijavascript kernel (npm install ijavascript)
        * itypescript kernel (npm install itypescript)
It replaces the beakerx java kernel with this one:
        * iJava kernel (binary realease from https://github.com/SpencerPark/IJava)

## How to run it

1. Use docker command to run it
    `docker run --rm -p 8888:8888 paulbuis/jupyter-many`

## License
MIT

## See Also:
*[jupyter-beakerx](https://github.com/paulbuis/jupyter-beakerx)
*[xeus-cling](https://github.com/QuantStack/xeus-cling)
*[ijava](https://github.com/SpencerPark/IJava)
*[ijavascript](http://n-riesco.github.io/ijavascript/)
*[itypescript](https://nearbydelta.github.io/itypescript/)
