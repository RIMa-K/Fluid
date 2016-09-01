/*
TODO:
 comment more.
 add trails to vehicles that fade over time.
 map a texture of something else to the behaviour. 
 try to fully understand code to work out how to do this.
 Can I have another simulation going on adding a dynamic layer?
 Can i convert the vehicles into a poligon mesh? 
 
 
 flowField following
 A two dimensional grid of vectors(a two dimentional array).
 what is the vehicles desired velocity?
 The arrows represents the desired velocity.
 The arrows can be configured using perlin noise amoung other number generators of data.
 
 Great for creating a fluid system.
 How do you calculate your flow field? 
 
 
 */

//Creat a flow object
flowField flow;
//ArrayList of Vehicles
ArrayList<Vehicle> vehicles;

PImage img;
int s;
int m;

void setup() {

  fullScreen(); 
  background(0);
  //load an alpha masked image to be applied as the vehicles texture.
  img = loadImage("dot..png");

  //Make a new flowField with a "resolution" of 20 
  flow = new flowField(10);
  vehicles = new ArrayList<Vehicle>();
  //Make lots of vehicles with random maxspeed and maxforce values
  //to create more vehicles divide height by smaller number.
  for (int i = 0; i< height/30; i++) {
    vehicles.add(new Vehicle(new PVector(random(width), random(height)), random(3, 6), random(0.1, 0.5)));
  }
}

void draw() {
  
  int s = second();
  int m = minute();
  //flow.display();
  //show time in seconds top left corner.
  //line(s, 0, s, 33);
  //Additive blending.
  blendMode(BLEND);

 //tell all the vehicles to follow the flow field
  for (Vehicle v : vehicles) {
    v.follow(flow);
    v.run();
    //change flowfield every 5 seconds.
    if (s % 12 == 0 ) flow.init(); 
    if(s == 15)
      img = loadImage("dot2.png");
      if (s == 30)
      img = loadImage("dot6.png");
      if (s == 45)
      img = loadImage("dot5.png");
      if (s == 59)
      img = loadImage("dot7.png");
      
     
  }
}