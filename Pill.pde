

class Pill {
  int x;
  int y;
  int offset;
  boolean vertical;
  Cell_colour[] pill_colours;

  Pill() {
    vertical=false;
    x=3;
    y=0;
    pill_colours=new Cell_colour[2];
    pill_colours[0]=Cell_colour.values()[(int) random(3)];
    pill_colours[1]=Cell_colour.values()[(int) random(3)];
    display();
  }
  void display() {
    //bottom left corner
    fill(pill_colours[0].screen_colour);
    ellipse(x*Grid_Size+.5*Grid_Size, y*Grid_Size+.5*Grid_Size+offset, Grid_Size, Grid_Size);
    //other one
    fill(pill_colours[1].screen_colour);
    if (vertical) {
      ellipse(x*Grid_Size+.5*Grid_Size, (y-1)*Grid_Size+.5*Grid_Size+offset, Grid_Size, Grid_Size);
    } else {
      ellipse((x+1)*Grid_Size+.5*Grid_Size, y*Grid_Size+.5*Grid_Size+offset, Grid_Size, Grid_Size);
    }
  }
  void move_down() {
    if (offset!=Grid_Size) {
      offset+=Grid_Size/20;
    } else {
      y++;
      offset=0;
    }
  }
  void turn(boolean turn_left){ 
    if((vertical&&turn_left)||(!vertical&&!turn_left)){
      Cell_colour temp=pill_colours[0];
      pill_colours[0]=pill_colours[1];
      pill_colours[1]=temp;
    }
  vertical=!vertical;
}
  
}