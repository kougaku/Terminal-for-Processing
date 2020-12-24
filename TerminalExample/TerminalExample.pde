Terminal term;
int angle = 0;

void setup() {
  size(600, 600);
  term = new Terminal(40, 10);
  term.setTextSize(25);

  // activate the window
  ((java.awt.Canvas) surface.getNative()).requestFocus();
}

void draw() {
  background(50);
  
  // terminal
  translate(40, 30);
  term.draw();

  // box
  translate(260, 400);
  rotate(radians(angle));
  fill(0, 200, 0);
  rectMode(CENTER);
  rect(0, 0, 100, 50);
  rectMode(CORNER);
}

void keyPressed() {
  // get input from terminal
  String input = term.keyEvent();
  if ( input == null ) return;
  if ( input == "" ) return;

  // parse command
  String[] v = split( input, " ");
  String cmd = v[0];

  // help command
  if ( cmd.equals("help") ) {
    term.println("---- HELP ----", color(0, 200, 200));
    term.println("rotate <angle>: rotate the box", color(0, 200, 200));
    term.println("exit : exit this program", color(0, 200, 200) );
  }
  // rotate command
  else if ( cmd.equals("rotate") ) {
    if ( v.length == 2 ) {
      angle += int(trim(v[1]));
    }
  }
  // exit command
  else if ( cmd.equals("exit") ) {
    exit();
  }
  // other
  else {
    term.println("command error.", color(161, 58, 77));
  }
}
