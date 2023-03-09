# STANNcam 🎥

https://user-images.githubusercontent.com/46312671/201537605-7193ed70-8db9-4647-bee9-ef039c9e85d7.mp4

## Features 💡

**STANNcam** is an easy to use camera and resolution manager object, and collection of associated scripts. Here's a list of features
- Upscaling, you can have a small game resolution and then upscale it, to allow pixel-perfect visuals
- Independant Game and GUI resolution, you can have a tiny game resolution and high quality GUI resolution.
- Following mode, if specified the camera will follow an object around, most commonly used to follow the player around in your game
- Moving and zooming, you can pan and zoom the camera into any location over a specified amount of time
- Fullscreen mode, you can easily switch to and from fullscreen mode

## Quickstart ✏️
go to the releases tab, and download the local package, and import it as a new project to see the example.

Or import it into your own project, excluding everything in the **Demonstration** folder. 

for using the camera it's good to have some manager object, maybe you use an init_game object, to put stanncam calls

Inside  create event write

``stanncam_init(game_res_width,game_res_height,resolution_width,resolution_height,gui_width,gui_height)``

(the last 4 params are optional and can be changed later)

this initializes the stanncam environment and creates a couple of global variables you can reference later

``global.game_width``

``global.game_height``

``global.gui_width``

``global.gui_height``

gui and game size can be identical, but you can make them independent if you'd like

and then you can create new cameras by writing

``my_cam_name = new stanncam(camera_width,camera_height)``

and then to finish off inside a post_draw event (in your init_game object or similar) you can render the camera

``my_cam_name.draw(0,0)``

## Feedback/Contact
If you have any issues, feedback or questions, you can write here on github,  
or refer to it's dedicated channel in Juju's kitchen discord server. 
https://discord.gg/Dac87U7XHS when you do feel free to tag me @stann_co so i see!

## Games using STANNcam 🎮
*Note all games are using older and specialised versions of the camera, but it is the same base in all*

[Pengu Saves Christmas](https://www.newgrounds.com/portal/view/825562)  
![firefox_1mAHf9ZqF8](https://user-images.githubusercontent.com/46312671/201538574-63a003b3-c2c2-4c8a-a7c0-f7149eafb7fa.png)

[BulbBoy](https://www.newgrounds.com/portal/view/837076)  
![3](https://user-images.githubusercontent.com/46312671/201538643-c079809f-d15e-481b-a0de-8363105f5727.png)

