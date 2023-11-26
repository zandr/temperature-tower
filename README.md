A Tiny Temperature Tower
===================

This is a tiny temperature tower.
I made it because I suspected my printer's hotend thermistor was reporting too cold.

`build.sh` generates `.3mf` files 
with extra code to make PrusaSlicer change temperatures automatically.

Defining A New Model
======================

You can add a new set of model parameters to `params.json`.

Let's say you named your new parameters `my-new-parameters`.
`build.sh my-new-parameters` will generate `my-new-parameters.3mf`,
with PrusaSlicer temperature changes and ponies and everything.
