# Trainer
This app will create an iPhone app that uses Tensorflow image recognition, trained on your own images. You can make a trail mix recognizer, a skin cancer detector, a cat in sofa detector, a cake recognizer, or whatever you can come up with. 
  
# Prepare
* Install Xcode 8 or higher
* Install Docker
* Install Git
* Make sure Docker and git are running
* To make training faster, open Docker `Preferences` > `Advanced`, and increase `CPUs` and `memory`

# Prepare your images and videos
* Start Trainer
* Click `Browse`
* You can train your model with both images and videos
* To train with images, go to `images/originals`
* Create a new folder named after the object you want the app to recognize, e.g. "burgers"
* Put pictures of burgers into the `burgers` folder
* To train with videos, go to `videos`
* Add your videos. Rename the video files e.g. `burgers1.mov`, `burgers2.mov`, etc

# Start training
* Click Start Training. The first training session will take about 30 minutes, depending on how many videos and images you have. 

# Make your app
* Click the Xcode icon. Creating your app will take about 45 minutes. 
* Go to ~/projects/tf_files/tensorswift_ios/tensorswift
* Open the xcode project and open `Config.swift`
* Add your labels and which web page the app should open when it recognizes them

# Add images to your model
* Add the images to `images/originals` and `videos`
* Click `Start Training`
* In Xcode's left hand file panel, delete the files in the folder 'model'
* Click `Reveal model files` and drag the files into the `model` folder in Xcode
