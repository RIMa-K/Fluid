
/*
the vehicle looks to the vector at it's current location.
 */


class Vehicle {
  // https://processing.org/reference/PVector.html
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;
  float maxspeed;

//float transparency = 255;

  Vehicle(PVector l, float ms, float mf) {
    location = l.copy();
    r = 2.0;
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
   
  }

  public void run() {
    update();
    borders();
    display();

  }

  //Implementing Reynolds' flow field algorithm

  void follow(flowField current) {
    //What is the vector at that spot in the flow field?
    PVector desired = current.lookup(location);
    //Scale it up by maxspeed
    desired.mult(maxspeed);
    //Steering is desired minus velecity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);//limit maximum steering force.
    applyForce(steer);
  }
  void applyForce(PVector force) {
    //I could add mass here A = F / M
    acceleration.add(force);
  }

  //Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);


  }
  

  void display() {

    pushMatrix();
    
    translate(location.x, location.y);
    imageMode(BLEND);

    image(img, r, r*2, 30, 30);
    
     //if (transparency > 0) { transparency -= 0.25; }
 // tint(255, transparency);
  
    //if (location.y < 1) tint(0, 153, 204);
    popMatrix();
  }

  //Wraparound
  void borders() {
    if (location.x < -r) location.x = width +r;
    if (location.y < -r) location.y = height +r;
    if (location.x > width +r) location.x = -r;
    if (location.y > height +r) location.y = -r;
  }

  }