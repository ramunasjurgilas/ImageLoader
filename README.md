# ImageLoader

The goal of this demo app is to provide an infinite scrolling list of images.
* Images provided remotely from here  http://dummyimage.com/300&text=text
* Images fetched in parallel, with no more than 4 images being fetched at once 
* On first launch images is loaded to fulfil visible cells 
* Image loading should be cancelled when a new scroll starts
* Images should not remain in memory when they are sufficiently off-screen 
* Storyboard was used to create UI.
