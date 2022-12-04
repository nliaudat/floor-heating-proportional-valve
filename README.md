# floor-heating-proportional-valve

# !!! BETA !!!! [Feel free to help](https://github.com/nliaudat/floor-heating-proportional-valve/blob/main/todo.md)

A smart DC proportional heating valve actuator

- Board : ESP-C3-01M
- Motor driver : L9110s
- Distance sensor : IR optocoupler (ITR8307)
- LDO regulator : AMS1117
- USB-UART : CH340C (removed)

<img src="https://github.com/nliaudat/floor-heating-proportional-valve/blob/main/imgs/demo1.gif">

# 3D printed proportional valve actuator 
Print actuator

Buy a motor : [GA12-N20-M3 15rpm 3V](https://fr.aliexpress.com/item/4000311295036.html?spm=a2g0s.12269583.0.0.18834b0ejbgKSj) ~3.5 $

<img src="https://github.com/nliaudat/floor-heating-proportional-valve/blob/main/imgs/GA12YN20-M3_dimensions.png" width="300">

If you do not have M30x1.5 valve, look at [adapters](https://github.com/nliaudat/floor-heating-proportional-valve/tree/main/adapters)

# Done :
- Esphome compilation with ESP32-C3 : only "esp-idf" framework works with "platformio_options: board_build.flash_mode: dio" fix
- Validate motor torque (can move 5mm), endstops at 90mV
- Validate power input AMS1117-3.3V
- Test proto board with external motorized valve (same motor and concept)
- Validate opto sensor 1-5mm
- Working openscad enclosure with sliding cursor to get IR-opto distance

<img src="https://github.com/nliaudat/floor-heating-proportional-valve/blob/main/imgs/proto_board.jpg" width="300">


# Contribute :
You can join easyeda project using that QR if you have skills in PCB creation (you must ask dev right on discussion with you easyeda username)

![qr](https://user-images.githubusercontent.com/6782613/190206632-bd1e3e5f-6982-4284-9096-a39a20921d45.png)

make another version (version management) for each step in dev

Please check [todo list](https://github.com/nliaudat/floor-heating-proportional-valve/blob/main/todo.md)

## Licence: 
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC-BY-NC-SA)
* No commercial use
