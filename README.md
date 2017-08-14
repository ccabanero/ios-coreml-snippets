# CoreML Code Snippets

![icon](imgs/coreml_logo.png)

Random code snippets while learning CoreML - an iOS framework for running trained Machine Learning models.

### Real-Time Object Detection

![screen](imgs/RealTimeObjectDetection.gif)

* Real-time capture using AVCaptureSession.
* Uses a CoreML Model (Resnet50.mlmodel) to detect objects within the captured data.
* Reports the detected objects and confidence level.

### Face Detection

![screen](imgs/FaceDetection.gif)

* User can choose a photo from their Photo Library.
* The Vision Framework is used to detect faces in the chosen photo.
* The detected bounding box around each face is drawn as a red rectangle in the image. Face bounding box remain when the photo is rotated from portrait to landscape.

<!--
### Converting a Machine Learning Model with CoreML Tools
-->

## References

* [Introducing CoreML](https://developer.apple.com/videos/play/wwdc2017/703/) - WWDC 2017 presentation
* [CoreML In Depth](https://developer.apple.com/videos/play/wwdc2017/710/) - WWDC 2017 presentation
* [CoreML Tools](https://pypi.python.org/pypi/coremltools) - for converting trained Machine Learning models for use in iOS apps.

## Connect

* Twitter: [@clintcabanero](http://twitter.com/clintcabanero)
* GitHub: [ccabanero](http:///github.com/ccabanero)
