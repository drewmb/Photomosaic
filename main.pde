PImage[] database;  // Array of database images
PImage target;      // Target image (best to make it medium sized: 640x480 or 1280x960)
int nrImages;       // Number of images in given Photomosaic database
int blockSize = 8;  // Size of both the tiles to be pulled out of the target image, and of the small database images themselves
int quality = 8;
// 32x32

int pixelX = 0;     // This will be used to locate the x-coordinate of the given picture
int pixelY = 0;     // This will be used to locate the y-coordinate of the given picture


float targetR;      // This variable will determine the red color of the selected pixel of the given picture
float targetG;      // This variable will determine the green color of the selected pixel of the given picture
float targetB;      // This variable will determine the blue color of the selected pixel of the given picture

float namesR;       // This variable will determine the red color of the selected pixel of the picture in a given Photomosaic database
float namesG;       // This variable will determine the green color of the selected pixel of the picture in a given Photomosaic database
float namesB;       // This variable will determine the blue color of the selected pixel of the picture in a given Photomosaic database

boolean isTarget = false;  // Checks to see if image has been selected

// These will be used to determine the right picture in the database for the corrosponding pixel of the given picture

float totalSum=0;
float min_d=0;
PImage matchLocation;

float targetPixel;


void setup() { // This is only specialized for me.  Will update it to have more versatility

  size(640, 480); // Default size.  This line can be edited according to any dimensions.

  //Get List of Images in Database Directory
  System.out.println(sketchPath);
  File file = new File(sketchPath + "\\data\\data\\ImageDatabase" + blockSize);  // Folder locator.  You can change the quotes to what your folder name actually is.
  String names[] = file.list();
  nrImages = names.length;
  println(nrImages);

  //Load In Images
  database = new PImage[nrImages];
  for (int i = 0; i <  nrImages; i++) {
    database[i] = loadImage(sketchPath + "\\data\\data\\ImageDatabase" + blockSize + "\\" + names[i]);  // Folder locator.  You can change the quotes to what your folder name actually is.
  }

  //Set up Display
  selectInput("Select Image", "fileSelected");  // Let's user select image of his/her choice
  
}

void draw(){
  if(isTarget){ // do not draw anything unless image is selected
  
    // folloing loops are used for sum of squared differences
    for (int targetX=0; targetX<60; targetX++) {
      for (int targetY=0; targetY<80; targetY++) {
        for (int i=0; i<nrImages; i++) {
          for (int x=0; x<quality; x++) {
            for (int y=0; y<quality; y++) {
            
              // gather the RGB values of each pixel in the original picture
              targetR = red(target.get((targetY*quality)+y, (targetX*quality)+x));
              targetG = green(target.get((targetY*quality)+y, (targetX*quality)+x));
              targetB = blue(target.get((targetY*quality)+y, (targetX*quality)+x));
            
              // gather the RGB values of each pixel in the database images
              namesR = red(database[i].get(y, x));
              namesG = green(database[i].get(y, x));
              namesB = blue(database[i].get(y, x));
            
              // use sum of squared differences to calculate the picture that best depicts the portion of the target image
              totalSum += abs(sq(targetR)-sq(namesR));
              totalSum += abs(sq(targetG)-sq(namesG));
              totalSum += abs(sq(targetB)-sq(namesB));
            }
          }
          // if the algorithm initially starts, automatically select the first database image as the most accurate
          if (i==0) { 
            min_d = totalSum;
            matchLocation = database[i];
          }
          // replace the database image when it's more accurate than the one that's being depicted
          else if (totalSum<min_d) {
            min_d = totalSum;
            matchLocation = database[i];
          }
          // reset the total sum
          totalSum = 0;
        }
        // place the most accurate image onto the photomosaic
        image(matchLocation, targetY*quality, targetX*quality);
      }
    }
  }
}

// This function initializes the user selected image to target
void fileSelected(File selection){
  if(selection==null)
    println("Window was closed");
  else{
    target = loadImage(selection.getAbsolutePath());
    isTarget = true;
  }
}
    
}
