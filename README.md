# Terminal for Processing

[![Image from Gyazo](https://i.gyazo.com/95a3486a6569ce19daf951d13891dfd0.gif)](https://gyazo.com/95a3486a6569ce19daf951d13891dfd0)

This code is just example, not library, but it would be helpful.
Please use Terminal.pde as library.


### Minimum code:
```scala
Terminal term;

void setup() {
  size(600, 600);
  
  // create terminal. 40 characters per line, 10 lines.
  term = new Terminal(40, 10);
  
  // text size
  term.setTextSize(25);
}

void draw() {
  background(50);
  
  // draw terminal
  translate(40, 30);
  term.draw();
}

void keyPressed() {
  // get input from terminal
  String input = term.keyEvent();
}
```
