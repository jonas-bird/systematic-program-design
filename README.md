# Systematic Program Design Projects

This repository contains projects related to the course [Systematic Program Design](https://cs.ossu.dev/coursepages/spd/) as well as the book [How to Design Programs 2nd edition](https://htdp.org/2024-11-6/Book/index.html) and related material

I doubt anyone would want to install/run this code. It is written in variations of BSL and the Dr. Racket editor. If you are working throug these materials yourself I would recommend not looking at a solution until you have designed and implemented your own version. This advice applies especially if you are trying to take on the [Open Source Society University](https://cs.ossu.dev) curriculum as you will undermine your own ability to take on later material by depriving yourself of the 'joy' of puzzling through the basic material


## Space Invaders

This is based on the starter file provided by OSSU, rather than built up from simpler versions as found int HtDP2

### Design notes

#### Rendering images

I am actually starting with this (even though this is probably the area where I struggle the most) as the starter file already gives me some images to use.

One thing I notice is that there is a function in the htdw2 teachpack `(place-images images posns scene)` that works with a list of images and a list of positions. While I could try to make one large list of the positions of the game elements and create a list of images by appending the image of the UFO and missiles into a list I think I am better off using `(place-image image x y scene)` in a recursive function (this is a Lisp dialect after all)
