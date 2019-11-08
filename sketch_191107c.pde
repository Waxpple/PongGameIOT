int ball_x = 90;
int ball_y=90;
int pad_x,pad_y=0;
int ball_vx = 8;
int ball_vy = 8;
int fps=0;
int score_flag=0;
int bar_x;
int max=0;
int min=999;
float scale=1;
int[] mean_value = new int[10];
import processing.serial.*;
import cc.arduino.*;
Arduino arduino;
int input= 0;
boolean start_flag= true;
JSONObject json;
JSONArray articles;
JSONObject a1;
int number;


void setup() {
  size(1024, 768, P3D);    
  arduino = new Arduino(this, Arduino.list()[1], 57600); //sets up arduino
  arduino.pinMode(input, Arduino.INPUT);//setup pins to be input (A0 =0?)
  
  json = loadJSONObject("https://newsapi.org/v2/top-headlines?country=us&apiKey=423f8c6511f34ecfb746fb4e82195494");
  articles = json.getJSONArray("articles");
  number = json.getInt("totalResults");
}

void draw() {
  background(255);
  delay(1);
  
  if(start_flag){
    delay(500);
    bar_x = arduino.analogRead(input);
    fill(255,0,0);
    text("Calibrate your sensor!",200,20);
    text("First, Darker value!",200,40);
    if(max<bar_x){
    max = bar_x;
    }
    text("Second, HIGH value!",200,60);
    if(min>bar_x){
    min = bar_x;
    }
    if(abs(max-min)!=0){
    scale=1024/abs(max-min);
    }
    text("OKAY!",200,80);
    text(max,70,270);
    text(min,70,290);
    rect(50,30,50,50);
    if(mouseX>50 & mouseX<100 & mouseY>30&mouseY<50){
      start_flag = false;
    }
    
}else{
  //bar_x = int((arduino.analogRead(input)-min)*scale);
  for(int c=0;c<10;c++){
    mean_value[c] = arduino.analogRead(input);
    delay(1);
  }
  
  bar_x = int(map(min(mean_value), min, max, 0, 1024));
  fps++;
  ball_x+=ball_vx;
  ball_y+=ball_vy;
  
  if(ball_x>996||ball_x<28){
  ball_vx *=-1;
  }
  if(ball_y<28){
  ball_vy *=-1;
  }
  if(ball_y>750){
    ball_y = 90;
    fps-=5000;
  }
  if(ball_y <750+28+3 & ball_y+28>750-3 &ball_x+28>bar_x-73 & ball_x<bar_x+73){
    
    if(ball_vy>0){
    ball_vy = -8;
    }
    //ball_vy *=-1;
    score_flag =1;
    
  }
  
  
  textSize(32);
text("Score:", 10, 30);
text(fps,100,30);
text(bar_x,10,400);
if(score_flag==1){
  fill(255,0,0);
  text("+500!",10,90);
  if(fps%100==0){
    score_flag=0;
    fps+=499;
  }
}
fill(117, 168, 50);
rect(0,100,1024,300);
a1 = articles.getJSONObject(abs(fps/30000)%10);
 String s1 = a1.getString("title");
 String s2 = a1.getString("description");
 fill(0,0,255);
 textSize(40); 
 
 //text(s1,0,200);
 for(int i =0;i<((s1.length())/45)+1;i++){
 fill(0,0,255);
 if(45*(i+1)>s1.length()){
  text(s1.substring(45*i,s1.length()),10,200+i*45);
 }else{
 text(s1.substring(45*i,45*(i+1)),10,200+i*45);
 }
 }
 textSize(30); 
 for(int i =0;i<(s2.length())/65+1;i++){
 fill(0,0,255);
 if(65*(i+1)>s2.length()){
  text(s2.substring(65*i,s2.length()),10,300+i*35);
 }else{
 text(s2.substring(65*i,65*(i+1)),10,300+i*35);
 }
 }
 //String s3 = a1.getString("content");
 //println((s3.length()));
 //s3.join('abcdd');
 
 
 
 //text(s3,0,400);
 
 fill(227, fps+5%255, fps%255);
  ellipse(ball_x, ball_y, 55, 55);
  fill(153, 227, 25);
  rect(bar_x-73,750,155,15,155);
}
}
