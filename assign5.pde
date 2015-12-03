//start
PImage start1;
PImage start2;

//end
PImage end1;
PImage end2;

//gameState
final int GAME_START = 1;
final int GAME_RUN = 2;
final int GAME_LOSE = 3;
int gameState = GAME_START;

//background
PImage bg1;
PImage bg2;
float bgFirstX = 0;
float bgSecondX = -641;

PImage enemy;
PImage shoot;
PImage fighter;
float fighterX = 640 - 51;
float fighterY = 480 / 2 - 51.0 / 2;
int enemyCount = 8;
int enemyState = 0;
int[] enemyX = new int[enemyCount];
int[] enemyY = new int[enemyCount];
int lastEnemy = 4;
int enemySpacing = 600;
boolean enemyComeIn = false;

//fighter
int fighterSpeed = 5;
boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

//shoot
boolean [] alreadyShoot = {false, false, false, false, false};
float [] shootX = {1000, 1000, 1000, 1000, 1000};
float [] shootY = new float [5];
int shootSpeed = 10;
int shootTimes = 0;

//treasure
PImage treasure;
float treasureX = random(600); //boundary control
float treasureY = random(440); //boundary control

//hp
PImage hp;
float hpX = (205-10)*20/100; //10<=hpX<=205, at least 20 points of blood ;

//now score
int score = 0;

//hit
boolean hitShootEnemy;
boolean hitEnemyFighter;
boolean hitFighterTreasure;

//distance
int [] distance = new int [8];

void setup () {
	size(640,480);
  start1 = loadImage("img/start1.png");
  start2 = loadImage("img/start2.png");
  end1 = loadImage("img/end1.png");
  end2 = loadImage("img/end2.png");
  bg1 = loadImage("img/bg1.png");
  bg2 = loadImage("img/bg2.png");
	enemy = loadImage("img/enemy.png");
  shoot = loadImage("img/shoot.png");
  fighter = loadImage("img/fighter.png");
  treasure = loadImage("img/treasure.png");
  hp = loadImage("img/hp.png"); 
	addEnemy(0);
}

void draw()
{
switch (gameState){  
   case GAME_START:
      image(start2, 0, 0);
      //mouse detecting
      if (mouseX >= width*95/300 && mouseX <= width*215/300 &&
          mouseY >= height*390/500 && mouseY <= height*435/500){
          image(start1, 0, 0);
      }else{
        image (start2, 0, 0);
      }
      //click to start
      if (mousePressed){
        if (mouseX >= width*95/300 && mouseX <= width*215/300 && 
            mouseY >= height*390/500 && mouseY <= height*435/500){
            gameState = GAME_RUN;
          }
      }
      break;
      
  case GAME_RUN: 
  //background
      image(bg1, bgFirstX, 0);
      image(bg2, bgSecondX, 0);
      bgFirstX++;
      bgSecondX++;
      
      if (bgFirstX >= 641){
        bgFirstX = -641;
      }
      if (bgSecondX >= 641){
        bgSecondX = -641;
      } 
  
  
  
  
  //fighter
      image(fighter, fighterX, fighterY); // the rightest, in the middle
        //derection controlling
      if (upPressed){
        fighterY -= fighterSpeed; 
      }
      if (downPressed){
        fighterY += fighterSpeed;
      }
      if (leftPressed){
        fighterX -= fighterSpeed;
      }
      if (rightPressed){
        fighterX += fighterSpeed;
      }
        //boundary controlling
      if (fighterX>589){
        fighterX = 589;
      }
      if (fighterX<0){
        fighterX = 0;
      }
      if (fighterY>429){
        fighterY = 429;
      }
      if (fighterY<0){
        fighterY = 0;
      }
      

     
      
      //shoot
      for(int i=0; i<5; i++){
        if(alreadyShoot[i] == true){
          image(shoot, shootX[i], shootY[i]);
          shootX[i] -= shootSpeed;
          int whichEnemy = closestEnemy(int(shootX[i]), int(shootY[i]));
          //chase the enemy
          if(shootX[i] > enemyX[whichEnemy] &&
             shootX[i] > enemyX[lastEnemy]  &&
             enemyX[0] > 0){
            if(shootY[i] > enemyY[whichEnemy]+61){
              shootY[i] -= 3;
            }else if(shootY[i]+27 < enemyY[whichEnemy]){
              shootY[i] += 3;
            }
          }else if(whichEnemy==-1){
            shootY[i]=shootY[i];
          }
          
         // println("done");
          if(shootX[i]+31<=0){
            alreadyShoot[i]=false;
          }
        }
      }
      
      //treasure
      image(treasure, treasureX, treasureY);
      
     
      
      //fighter eats treasure
      if(hitFighterTreasure = isHit(fighterX, fighterY, 51, 51, treasureX, treasureY, 41, 41))
        {
          
         if(hpX<=205){
           hpX = hpX + (205-10)*10/100;
         } // add blood 10%
         treasureX = random(600); 
         treasureY = random(440);
       }
  
      //enemy hits fighter
      for(int i=0; i<8; i++){
        if(hitEnemyFighter = isHit(enemyX[i], enemyY[i], 61, 61, fighterX, fighterY, 51, 51)){
          enemyY[i] = 481;
          hpX = hpX - (205-10)*20/100;
          
        }
      }
  
  
  
  
  
  
  
  
      //shoot enemy
     for(int j=0; j<5; j++){
       for(int i=0; i<8; i++){
         if(shootX[j]>=0){
           
           if( hitShootEnemy = isHit(enemyX[i], enemyY[i], 61, 61, shootX[j], shootY[j], 31, 27)){
    
               // println(score); 
                scoreChange(20);
                enemyY[i]=481; //outside the screen
                shootX[j]=-100;//outside the screen
                alreadyShoot[j] = false; 
           }
      
           /*if(abs((enemyX[i]+61.0/2)-(shootX[j]+31.0/2))<=46 &&
              abs((enemyY[i]+61.0/2)-(shootY[j]+27.0/2))<=44)
              { println(score); 
                score += 20;
                enemyY[i]=481; //outside the screen
                shootX[j]=-100;//outside the screen
                alreadyShoot[j] = false; 
             }*/
         }
       }
     } 
      
	for (int i = 0; i < enemyCount; ++i) {
		if (enemyX[i] != -1 || enemyY[i] != -1) {
			image(enemy, enemyX[i], enemyY[i]);
			enemyX[i]+=5;
          }//if end
          
          //switch the enemy team
          if (enemyState == 1){
            if( enemyX[4]>=width+enemySpacing){
              addEnemy(1);
            }
            lastEnemy = 4;
          };
          
          if (enemyState == 2){
            if( enemyX[4]>=width+enemySpacing){
              addEnemy(2);
            }
            lastEnemy = 4;
          }
          
          if (enemyState == 3){
            if( enemyX[7]>=width+enemySpacing){
              addEnemy(0);
            }
            lastEnemy = 7;
          }

          
          
          
	}//for end

   //hp
      fill(#CC0000);
      rectMode(CORNERS);
      if(hpX>=205){
        hpX=205;
      }
      rect(10,4.2,hpX,24); //under
      image(hp, 0, 0); //above


  //text
  textSize(32);
  text("SCORE:", 20, 450);
  text(score, 180, 450);
  
  //println("hpX="+hpX);
  //when to gameover
     if (hpX <= 10){
       gameState = GAME_LOSE;
     }
  
  break;
  
  case GAME_LOSE:
      image(end2, 0, 0);
      if (mouseX >= width*96/300 && mouseX <= width*205/300 && mouseY >= height*257/400 && mouseY <= height*292/400){
        image(end1, 0, 0);
      }else{
        image(end2, 0, 0);
      }
      hpX = (205-10)*20/100; 
      fighterX = 640 - 51;
      fighterY = 480 / 2 - 51.0 / 2;
      score = 0;
      for(int i=0; i<8; i++){
        enemyX[i]= -1;
      }
      
      //click to restart
      if (mousePressed){
        if (mouseX >= width*96/300 && mouseX <= width*205/300 && 
            mouseY >= height*257/400 && mouseY <= height*292/400){
            gameState = GAME_RUN;
            addEnemy(0);
          }
      }
  
  
  
}//switch end
} //draw end


void scoreChange(int value){
  score = score + value;
}


// 0 - straight, 1-slope, 2-dimond
void addEnemy(int type)
{	
	for (int i = 0; i < enemyCount; ++i) {
		enemyX[i] = -1;
		enemyY[i] = -1;
	}//for end
	switch (type) {
		case 0:
			addStraightEnemy();
			break;
		case 1:
			addSlopeEnemy();
			break;
		case 2:
			addDiamondEnemy();
			break;
	}//switch end
}//addEnemy end

void addStraightEnemy()
{
  enemyState = 1;
	float t = random(height - enemy.height);
	int h = int(t);
	for (int i = 0; i < 5; ++i) {

		enemyX[i] = (i+1)*-80;
		enemyY[i] = h;
	}//for end
}//addStraightEnemy end

void addSlopeEnemy()
{ 
  enemyState = 2;
 	float t = random(height - enemy.height * 5);
	int h = int(t);
	for (int i = 0; i < 5; ++i) {

		enemyX[i] = (i+1)*-80;
		enemyY[i] = h + i * 40;
	}//for end
}//addSlopeEnemy end


void addDiamondEnemy()
{
  enemyState = 3;
	float t = random( enemy.height * 3 ,height - enemy.height * 3);
	int h = int(t);
	int x_axis = 1;
	for (int i = 0; i < 8; ++i) {
		if (i == 0 || i == 7) {
			enemyX[i] = x_axis*-80;
			enemyY[i] = h;
			x_axis++;
		}
		else if (i == 1 || i == 5){
			enemyX[i] = x_axis*-80;
			enemyY[i] = h + 1 * 40;
			enemyX[i+1] = x_axis*-80;
			enemyY[i+1] = h - 1 * 40;
			i++;
			x_axis++;
			
		}
		else {
			enemyX[i] = x_axis*-80;
			enemyY[i] = h + 2 * 40;
			enemyX[i+1] = x_axis*-80;
			enemyY[i+1] = h - 2 * 40;
			i++;
			x_axis++;
		}
	}//for end
}//addDiamondEnemy end

boolean isHit(float ax, float ay, float aw, float ah, float bx, float by, float bw, float bh){
  if( abs((ax+aw/2)-(bx+bw/2))<=(aw/2+bw/2) &&
      abs((ay+ah/2)-(by+bh/2))<=(ah/2+bh/2) ){
        return true;
       }else{
        return false;
       }
}

int closestEnemy(int x, int y){
  
    distance[0] = int(dist(x, y, enemyX[0], enemyY[0]));
    distance[1] = int(dist(x, y, enemyX[1], enemyY[1]));
    distance[2] = int(dist(x, y, enemyX[2], enemyY[2]));
    distance[3] = int(dist(x, y, enemyX[3], enemyY[3]));
    distance[4] = int(dist(x, y, enemyX[4], enemyY[4]));
    distance[5] = int(dist(x, y, enemyX[5], enemyY[5]));
    distance[6] = int(dist(x, y, enemyX[6], enemyY[6]));
    distance[7] = int(dist(x, y, enemyX[7], enemyY[7]));
    int minEnemy = min(distance);
    if(minEnemy == distance[0]){
      return 0;
    }else if(minEnemy == distance[1]){
      return 1;
    }else if(minEnemy == distance[2]){
      return 2;
    }else if(minEnemy == distance[3]){
      return 3;
    }else if(minEnemy == distance[4]){
      return 4;
    }else if(minEnemy == distance[5]){
      return 5;
    }else if(minEnemy == distance[6]){
      return 6;
    }else if(minEnemy == distance[7]){
      return 7;
    }else {
      return -1;
    }
      

}

void keyPressed(){
  if (key==CODED){
    switch(keyCode){
      case UP:
        upPressed = true;
      break;
      case DOWN:
        downPressed = true;
      break;
      case LEFT:
        leftPressed = true;
      break;
      case RIGHT:
        rightPressed = true;
      break;
    }
  }
  if(keyCode == ' '){
     if(alreadyShoot[shootTimes] == false){
      alreadyShoot[shootTimes] = true;
      shootX[shootTimes] = fighterX;
      shootY[shootTimes] = fighterY;
      shootTimes = (shootTimes + 1) % 5;
     }
  }
} //keyPressed end

void keyReleased(){
  if (key==CODED){
      switch(keyCode){
        case UP:
          upPressed = false;
        break;
        case DOWN:
          downPressed = false;
        break;
        case LEFT:
          leftPressed = false;
        break;
        case RIGHT:
          rightPressed = false;
        break;
      }
  }
} //keyReleased end
