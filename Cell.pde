enum Cell_colour {
  red(#ff0000), blue(#085BFC), yellow(#FCF508);
  color screen_colour;
  private Cell_colour(color pigement) {
    this.screen_colour=pigement;
  }
}
enum cell_type {
  virus, pill
}

class Cell {
  int x;
  int y;
  Cell_colour colour;  
  cell_type type;

  Cell(int x, int y, cell_type type, Cell_colour colour) {
    this.x=x;
    this.y=y;
    this.type=type;
    this.colour=colour;
    display();
  }

  void display() {
    fill(this.colour.screen_colour);
    if (type==cell_type.virus) {
      rect(x*Grid_Size, y*Grid_Size, Grid_Size, Grid_Size);
    } else {
      ellipse(x*Grid_Size+(.5*Grid_Size), y*Grid_Size+(.5*Grid_Size), Grid_Size, Grid_Size);
    }
  }
}