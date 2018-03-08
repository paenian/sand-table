#!/bin/sh

#this file compiles many of the useful parts into their own directory
#for mixing and matching.

openscad -o crossbot_stls/magnet_carriage.stl -D part=0 crossbot.scad &
openscad -o crossbot_stls/double_idler.stl -D part=1 crossbot.scad &
openscad -o crossbot_stls/beam_carriage.stl -D part=2 crossbot.scad &
openscad -o crossbot_stls/motor_mount.stl -D part=3 crossbot.scad &
openscad -o crossbot_stls/offset_motor_mount.stl -D part=4 crossbot.scad &
openscad -o crossbot_stls/base_beam_mount.stl -D part=5 cirossbot.scad &
openscad -o crossbot_stls/motor_beam_mount.stl -D part=6 crossbot.scad &
