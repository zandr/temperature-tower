A Tiny Temperature Tower
===================

This is a tiny temperature tower.
I made it because I suspected my printer's hotend thermistor was reporting too cold.

(I think I was right.)


Building
----------

This uses make(1).
If you've never used make(1) before,
here's a quick introduction:

    make all      # Build everything
    make clean    # Remove build files
    make targets  # List everything you can build


Building A New Model
---------------------------

You can add a new set of model parameters to [params.json](params.json).

Let's say you named your new parameters `my-new-parameters`.

    make my-new-parameters.3mf  # Build only your model

The resulting 3mf file will have 
temperature changes for PrusaSlicer
and ponies
and everything!
