
class Terminal {
  // must use monospaced font.
  String fontName = "RictyDiminished-Bold.ttf";

  final color DEFAULT_TEXT_COLOR = color(200, 200, 200);
  final color DEFAULT_CURRENT_TEXT_COLOR = color(200, 200, 0);  
  final float DEFAULT_MARGIN = 10;
  final float DEFAULT_CHAR_SIZE = 30;

  final int DEFAULT_MAX_TEXT_LENGTH = 48;  // per 1 line
  final int DEFAULT_MAX_DISPLAY_LINE = 14;
  final int DEFAULT_MAX_LOG_SIZE = 500;
  final int DEFAULT_MAX_COMMAND_LOG_SIZE = 100;

  PFont font;  
  ArrayList<Text> log = new ArrayList<Text>();  
  ArrayList<String> commandLog = new ArrayList<String>();

  float margin = DEFAULT_MARGIN;
  float charSize = DEFAULT_CHAR_SIZE;
  int maxTextLength = DEFAULT_MAX_TEXT_LENGTH;
  int maxShowLine = DEFAULT_MAX_DISPLAY_LINE;
  int maxLogSize = DEFAULT_MAX_LOG_SIZE;
  int maxCommandLogSize = DEFAULT_MAX_COMMAND_LOG_SIZE;
  int command_index = -1;
  float charWidth;  
  float charHeight;

  Terminal(int _maxTextLength, int _maxShowLine ) {
    maxTextLength = _maxTextLength;
    maxShowLine = _maxShowLine;
    initFont();

    // first line
    addBlankLine();
  }

  void initFont() {
    // init font settings
    pushStyle();
    {
      font = createFont(fontName, charSize);
      textFont(font);
      textSize(charSize);
      charWidth = textWidth("A");
      charHeight = textAscent() + textDescent();
    }   
    popStyle();
  }

  void draw() {
    pushStyle();
    pushMatrix();
    // ========================================================================

    // background
    noStroke();
    fill(25);
    rect( 0, 0, margin*2 + maxTextLength * charWidth, margin * 2 + maxShowLine * charHeight );
    translate(margin, margin);

    // translate
    int log_line_count = 0;
    for ( Text t : log ) {
      log_line_count += t.lineCount();
    }
    int show_lines = min( maxShowLine, log_line_count );      
    translate( 0, (show_lines -1 ) * charHeight );

    // text settings
    textFont(font);
    textSize(charSize);
    textAlign(LEFT, TOP);
    textLeading(charHeight);

    // draw log
    int line_count = 0;
    for (int i=log.size()-1; i>=0; i--) {
      Text line = log.get(i);
      for (int k=line.lineCount()-1; k>=0; k--) {
        String sub = line.str.substring( k*maxTextLength, min(line.str.length(), (k+1)*maxTextLength) );
        fill(line.col);
        text(sub, 0, 0);        
        if ( line_count == 0 ) {  // cursor 
          noStroke();
          fill(255, 255, 255, 10 * frameCount % 255);
          rect( textWidth(sub), 0, charWidth*0.15, charHeight );
        }
        translate(0, -charHeight);
        line_count++;
        if ( line_count >= show_lines ) break;
      }
      if ( line_count >= show_lines ) break;
    }

    // ========================================================================
    popMatrix();
    popStyle();
  }

  void setTextSize(int s) {
    charSize = s;
    initFont();
  }

  void println(String str) {
    this.println(str, DEFAULT_TEXT_COLOR);
  }

  void println(String str, color col) {
    Text last = log.get(log.size()-1);
    last.str = str;
    last.col = col;
    addBlankLine();
    while ( log.size() > maxLogSize ) {
      log.remove(0);
    }
  }

  void addBlankLine() {
    log.add( new Text("", color(DEFAULT_CURRENT_TEXT_COLOR)));
  }

  String keyEvent() {
    Text last = log.get(log.size()-1);

    if ( keyCode == ENTER ) {
      String command = last.str;
      last.col = DEFAULT_TEXT_COLOR;
      addBlankLine();
      command_index = -1;
      if ( !command.equals("") ) {
        commandLog.add(0, command);
        if ( commandLog.size() > maxCommandLogSize ) {
          commandLog.remove(0);
        }
      }
      return command;
    }
    //
    else if ( keyCode == BACKSPACE ) {
      if ( last.str.length() > 0 ) {
        last.str = last.str.substring(0, last.str.length()-1);
      }
    }
    //
    else if ( keyCode == UP ) {
      if ( commandLog.size() > 0 ) {
        if ( command_index < commandLog.size() -1 ) {
          command_index++;
        }
        last.str = commandLog.get(command_index);
      }
    }
    //
    else if ( keyCode == DOWN ) {
      if ( commandLog.size() > 0 ) {
        if ( command_index > -1 ) {
          command_index--;
        }
        if ( command_index == -1 ) {
          last.str = "";
        } else {
          last.str = commandLog.get(command_index);
        }
      }
    }
    //
    else if ( key != CODED ) {
      last.str += key;
    }
    return null;
  }

  class Text {
    String str;
    color col;    

    Text(String _str, color _col) {
      str = _str;
      col = _col;
    }

    int lineCount() {
      return (this.str.length() - 1) / maxTextLength + 1;
    }
  }
}
