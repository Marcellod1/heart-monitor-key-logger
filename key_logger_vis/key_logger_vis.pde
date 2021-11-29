// Constants
static final int WINDOW_WIDTH = 1300;
static final int WINDOW_HEIGHT = 600;
static final int NEUTRAL_Y = WINDOW_HEIGHT / 2;
static final int POS_Y = WINDOW_HEIGHT / 4;
static final int POS_CAPITAL_Y = WINDOW_HEIGHT / 6;
static final int NEG_Y = NEUTRAL_Y + (WINDOW_HEIGHT / 4);
static final float DELTA_X = 1.3;
static final float ELLIPSE_GROW_RATE = 0.2;

// Program state variables
String curr_key = "";
String prev_key = "";

float curr_y = NEUTRAL_Y;
float curr_x = 0;
float prev_y = curr_y;
float prev_x = curr_x;

boolean print_letter = true;
boolean paused = false;
ArrayList<String> key_log = new ArrayList<String>();

float mouse_hold = 1;

// Set the size of the window using the global constants
void settings() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
}


// Run once
void setup(){   
  background(0,0,0);
}


// Mouse pressed event
void mousePressed(){  
   curr_y = POS_Y;
  /* function runs when mouse is pressed, draws an ellipse coded by the button color
  and decides on the next line color drawn in draw() */
  if (mouseButton == LEFT) {
    curr_key = "ML";
    stroke(255,255,255);
    
  } else if (mouseButton == RIGHT) {
    curr_key = "MR";
    stroke(128,128,128);
    
  } else {
    curr_key = "";
    curr_y = NEUTRAL_Y;  
  }
}

// mouse release event
void mouseReleased(){
  print_letter = true;
  curr_y = NEUTRAL_Y;
}


// Key pressed event
void keyPressed(){    
  // Save the current key for printing
  curr_key = Character.toString(key);  
  curr_y = POS_Y;
    
  if (keyCode == 10 ){  // ENTER toggles pause state
    curr_y = NEUTRAL_Y;
    paused = !paused; 
    
  } else if (keyCode == 8){  // BACKSPACE
     // Pop the last element of the key log and display
     if(key_log.size() > 0){
       curr_key = key_log.remove(key_log.size() - 1);
     } else {
       curr_key = "";
     }
    curr_y = NEG_Y;
    stroke(255,0,0);
    
  } else if (keyCode == 32){  // SPACE
    curr_key = "";
    curr_y = NEUTRAL_Y;
    curr_x = curr_x + 10;
    prev_x = curr_x;
    stroke(0,255,0);
    
  } else if (keyCode == 38){  // ARROW KEYS
    curr_key = "up";
    stroke(255,255,0);
    
  } else if (keyCode == 40){
    curr_key = "dwn";
    stroke(255,255,0);
    
  } else if (keyCode == 37){
    curr_key = "lft";
    stroke(255,255,0);
    
  } else if (keyCode == 39){
    curr_key = "rgt";
    stroke(255,255,0);
    
  } else if ((keyCode >= 33 && keyCode <= 47) || (keyCode >= 58 && keyCode <= 64) || (keyCode >= 91 && keyCode <= 96)){  // Punctuation
    key_log.add(curr_key);  // add character to the key log
    curr_y = POS_Y;
    stroke(255,255,0);
    
  } else if (keyCode >= 65 && keyCode <= 90){  // Letters
    key_log.add(curr_key);  // add character to the key log
    
    if(Character.isUpperCase(key)){
      curr_y = POS_CAPITAL_Y;
    } else {
      curr_y = POS_Y;
    }
    
    stroke(0,255,0);
    
  } else if (keyCode >= 48 && keyCode <= 57){  // Numbers
    key_log.add(curr_key);  // add character to the key log
    curr_y = POS_Y;
    stroke(0,0,255);
    
  } else {
    curr_key = "";
    curr_y = NEUTRAL_Y;
    stroke(0,255,0);
  }
}


// Key released event, resets y to neutral state, resets print letter flag
void keyReleased(){
  print_letter = true;
  curr_y = NEUTRAL_Y;
}


// Run repeatedly
void draw(){  
  strokeWeight(2.5);
  textSize(15);
  
  // Wrap the animation
  if (curr_x > WINDOW_WIDTH || curr_x == 0){
    clear();
    curr_x = 0;
    prev_x = curr_x;
    stroke(0,255,0);
  }
  
  if(!paused){
    
    // Growing circles around mouse input points
    if(mousePressed) mouse_hold +=ELLIPSE_GROW_RATE;
    else mouse_hold = 0;
    
    if (mousePressed && (mouseButton == LEFT)) {
      fill(255);
    } else if (mousePressed && (mouseButton == RIGHT)) {
      fill(128);
    }
    
    ellipse(mouseX, mouseY, mouse_hold, mouse_hold);
  
    // Print text on respective lines
    if(print_letter && (keyPressed || mousePressed)){
        fill(0, 255, 255);
        if(curr_y < NEUTRAL_Y){
          text(curr_key, curr_x - 5, curr_y - 20);
        } else {
          text(curr_key, curr_x - 5, curr_y + 20);
        }
        print_letter = false;
      }
     
    // draw a line between the previous pos and the current pos
    line(prev_x, prev_y, curr_x, curr_y);
    
    // Increment and save current values
    prev_x = curr_x;
    prev_y = curr_y;
    curr_x += DELTA_X;
  }
}
