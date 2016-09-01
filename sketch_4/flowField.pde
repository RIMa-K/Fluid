/*
This class describes a grid of vectors aka the flowfield.
 The grid structure's information is stored within a 2D array. 
 https://processing.org/tutorials/2darray/
 */

class flowField {

  //A flow field is a two dimensional array of PVectors
  PVector[][] field;
  //columns and rows.
  int cols, rows; 
  // how large is each "cell" of the flow field in relation to the window.
  int resolution; 
  //minute() function returns the current minute as a value from 0-59.
  float  m = minute();
  float s = second();

  flowField(int r) {
    resolution = r;
    //determine the number of columns and rows based on the output window size.
    //total columns equals width divided by resolution.
    cols = width/resolution;
    //total rows equals height divided by resolution.
    rows = height/resolution;
    field = new PVector[cols][rows];
    init();
  }

  //compute the vectors in the flow field.
  void init() {
    noiseSeed((int)random(10000));
    
//map what minute in time we are to a range between 0.05 and 0.1.
    //float time = map(m, 0,59, 0.01, 0.1);

    float xoff =0;
    for (int i = 0; i < cols; i++) {
      float yoff =0;
      for (int j = 0; j < rows; j++) {
        //use 2D Perlin Noise mapped to an angle.
        //  https://processing.org/reference/noise_.html
        float theta = map(noise(xoff, yoff), 0, 1, 0, TWO_PI);
        //Polar to Cartesian coordinate transformation to get x and y components of the vector.
        field[i][j] = new PVector(cos(theta), sin(theta));
        //time value is dictated by minite in time.
        yoff += 0.1;
      }
      xoff += 0.1;
    }
  }



  //Draw every vector
  void display() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        drawVector(field[i][j], i*resolution, j*resolution, resolution-2);
      }
    }
  }
  void drawVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float objsize = 6;
    //Translate to location to render vector
    translate(x, y);
    //call vector heading function to get direcion(note: pointing to the right is a heading of 0) and rotate. 
    rotate(v.heading());
    //calculate length of vector & scale it to be bigger or smaller if needed.
    float len = v.mag()*scayl;
    //draw elipse
    ellipse(0, 0, len, 0);
    popMatrix();
  }

  //A function called lookup() which recieves a PVector(the location of the vehicle) 
  //...and returns the corresponding flow field PVector for that location.
  PVector lookup(PVector lookup) {
    //divide the resolution of the grid, then use the constrain() function to stop the vehicle
    //...looking outside the flowfield array(grid).
    int column = int(constrain(lookup.x/resolution, 0, cols-1));
    int row = int(constrain(lookup.y/resolution, 0, rows-1));
    return field[column][row].copy();  //replaced get() with copy() as get() is depreciated.
  }
}