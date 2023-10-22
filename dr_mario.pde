import java.util.*; //<>// //<>//


static final int Grid_Size=40;
enum state {
  place_virus, new_pill, pill_fall, check, disapear, cell_fall
}
boolean vertical_linkage;
int x_linkage;
int num_virus;
Pill the_pill;
state game_state;

List <int[]>mt_spaces;

Cell [][] bottle;
List<Cell> viruses; 
List<Cell> pills;

void settings() {
  x_linkage=3;
  size(Grid_Size*8, Grid_Size*17, P2D);
}

void setup() {
  background(0);
  num_virus=1;
  mt_spaces=new ArrayList(8*13);
  viruses=new ArrayList(num_virus);
  bottle=new Cell [8][17];
  pills=new ArrayList();
  start_level();
  frameRate(50);
}

void draw() {
  background(0);
  for (Cell virus : viruses) {
    virus.display();
  }
  for (Cell pill : pills) {
    pill.display();
  }
  switch(game_state) {
  case place_virus:
    if (viruses.size()<num_virus&&!!!mt_spaces.isEmpty()) {
      int[] place=mt_spaces.remove(0);
      int x = place[0];
      int y = place[1];
      //println("adding at "+x+","+y);
      Cell_colour virus_colour=colour_pick(x, y);
      if (virus_colour!=null) {
        Cell virus=new Cell(x, y, cell_type.virus, virus_colour);
        bottle [x][y]= virus;
        viruses.add(virus);
      }
    } else {
      println("starting new pill");
      game_state=state.new_pill;
    }
    break;
  case new_pill:
    //new Pill();
    the_pill=new Pill();
    println("starting pill fall");
    game_state=state.pill_fall;
    x_linkage=the_pill.x;
    vertical_linkage=the_pill.vertical;
    break;
  case pill_fall:
    the_pill.move_down();   
    if (the_pill.offset==0) {
      the_pill.x=x_linkage;
      vertical_linkage=the_pill.vertical;
    }
    if (the_pill.y<16&&bottle[the_pill.x][the_pill.y+1]==null
      && (the_pill.vertical||bottle[the_pill.x+1][the_pill.y+1]==null)) {
      the_pill.display();
    } else {

      Cell pill=new Cell(the_pill.x, the_pill.y, cell_type.pill, the_pill.pill_colours[0]);
      bottle[the_pill.x][the_pill.y]=pill;
      Cell pill2;
      if (the_pill.vertical) {
        pill2=new Cell(the_pill.x, the_pill.y-1, cell_type.pill, the_pill.pill_colours[1]);
        bottle[the_pill.x][the_pill.y-1]=pill2;
      } else {
        pill2=new Cell(the_pill.x+1, the_pill.y, cell_type.pill, the_pill.pill_colours[1]);
        bottle[the_pill.x+1][the_pill.y]=pill2;
      }
      pills.add(pill);
      pills.add(pill2);
      println("starting check");
      game_state=state.new_pill;
    }
    this.key_check();
    break;
  case check:

    break;
  case disapear:

    break;
  case cell_fall:

    break;
  }
}
void start_level() {
  mt_spaces.clear();
  pills.clear();
  viruses.clear();
  for (int x=0; x<8; x++) {
    for (int y=4; y<17; y++) {
      mt_spaces.add(new int[]{x, y});
    }
  }
  Collections.shuffle(mt_spaces);
  game_state=state.place_virus;
  println("starting place virus");
  loop();
}
Cell_colour colour_pick(int x, int y) {
  EnumSet<Cell_colour> available = EnumSet.allOf(Cell_colour.class);
  // check horz x
  if (x>0&&x<7&&bottle[x-1][y]!=null&&bottle[x+1][y]!=null&&bottle[x-1][y].colour==bottle[x+1][y].colour) {
    available.remove(bottle[x-1][y].colour);
  }
  //check vert y
  if (y>0&&y<16&&bottle[x][y-1]!=null&&bottle[x][y+1]!=null&&bottle[x][y-1].colour==bottle[x][y+1].colour) {
    available.remove(bottle[x][y-1].colour);
  }
  //check 2 up
  if (bottle[x][y-1]!=null&&bottle[x][y-2]!=null&&bottle[x][y-1].colour==bottle[x][y-2].colour) {
    available.remove(bottle[x][y-1].colour);
  }
  //check 2 down
  if (y>0&&y<15&&bottle[x][y+1]!=null&&bottle[x][y+2]!=null&&bottle[x][y+1].colour==bottle[x][y+2].colour) {
    available.remove(bottle[x][y+1].colour);
  }
  //check 2 left
  if (x>1&&bottle[x-1][y]!=null&&bottle[x-2][y]!=null&&bottle[x-2][y].colour==bottle[x-1][y].colour) {
    available.remove(bottle[x-1][y].colour);
  }
  //check 2 right
  if (x<6&&bottle[x+1][y]!=null&&bottle[x+2][y]!=null&&bottle[x+1][y].colour==bottle[x+2][y].colour) {
    available.remove(bottle[x+1][y].colour);
  }
  if (!available.isEmpty()) {
    return available.toArray(new Cell_colour[0])[(int)random (available.size())];
  } else {
    println("failed to draw");
    return null;
  }
}

void key_check() {
  if (keyPressed) {
    if ((key=='w'||key==UP)&&vertical_linkage==the_pill.vertical&&the_pill.x<7&&
      bottle[the_pill.x+1][the_pill.y+1]==null&&bottle[the_pill.x][the_pill.y]==null) {
      the_pill.turn(true);
    } else if ((key=='s'||key==DOWN)&&vertical_linkage==the_pill.vertical&&the_pill.x<7&&
      bottle[the_pill.x+1][the_pill.y+1]==null&&bottle[the_pill.x][the_pill.y]==null) {
      the_pill.turn(false);
    } else if ((key=='a'||key==LEFT)&&the_pill.x>0&&the_pill.y<16) {
      if (bottle[the_pill.x-1][the_pill.y+1]==null
        &&(!the_pill.vertical||bottle[the_pill.x-1][the_pill.y]==null)) {
        x_linkage=the_pill.x-1;
      }
    } else if ((key=='d'||key==RIGHT)&&the_pill.x<7&&the_pill.y<16) {
      if ((the_pill.vertical&&bottle[the_pill.x+1][the_pill.y+1]==null&&bottle[the_pill.x+1][the_pill.y]==null)
        ||(!the_pill.vertical&&the_pill.x<6&&bottle[the_pill.x+2][the_pill.y+1]==null)) {
        x_linkage=the_pill.x+1;
      }
    } else {
      println("wasd");
      println("UP LEFT DOWN RIGHT");
    }
  }
}