//
// DrawnShape
// This class stores a draw shapes active on the canvas, and is responsible for
// 1/ Interpreting the mouse moves to successfully draw a shape
// 2/ Redrawing the shape, once it is drawn
// 3/ Detecting selection events, and selecting the shape if necessary
// 4/ modifying the shape once it is drawn through further actions
// 5/ Saving the drawn shape to file, and loading a shape from file
// The Displaylist contains a list of such items

class DrawnShape {
  // type of shape
  // line
  // circle
  // Rect .....
  String shapeType;
  
  ArrayList<PVector> points = new ArrayList<PVector>();
  public  int lineThickness =1;
  public boolean filled = true;
  public color fillColor = color(127, 127, 127);
  float arcAngle = QUARTER_PI;

  // used to define the shape bounds during drawing and after
  PVector shapeStartPoint, shapeEndPoint;

  boolean isSelected = false;
  boolean isBeingDrawn = false;
  
  
  public DrawnShape(String shapeType) {
    this.shapeType  = shapeType;
  }

  public void startMouseDrawing(PVector startPoint) {
    this.isBeingDrawn = true;
    this.shapeStartPoint = startPoint;
    this.shapeEndPoint = startPoint;
  }



  public void duringMouseDrawing(PVector dragPoint) {
    if (this.isBeingDrawn) this.shapeEndPoint = dragPoint;
  }


  public void endMouseDrawing(PVector endPoint) {
    this.shapeEndPoint = endPoint;
    
    this.isBeingDrawn = false;
  }


  public boolean tryToggleSelect(PVector p) {
    
    UIRect boundingBox = new UIRect(shapeStartPoint, shapeEndPoint);
   
    if ( boundingBox.isPointInside(p)) {
      this.isSelected = !this.isSelected;
      return true;
    }
    return false;
  }

 

  public void drawMe() {

    if (this.isSelected) {
        setSelectedDrawingStyle();
        if (filled == true) fill(fillColor);
        if (filled == false) noFill();
      }
      else{
        setDefaultDrawingStyle();
      }
    
    float x1 = this.shapeStartPoint.x;
    float y1 = this.shapeStartPoint.y;
    float x2 = this.shapeEndPoint.x;
    float y2 = this.shapeEndPoint.y;
    float w = x2-x1;
    float h = y2-y1;
    
    if ( shapeType.equals("draw rect")) rect(x1, y1, w, h);
    if ( shapeType.equals("draw circle")) ellipse(x1+ w/2, y1 + h/2, w, h);
    if ( shapeType.equals("draw line")) line(x1, y1, x2, y2);
    if (shapeType.equals("draw arc")) arc(x1, y1, w, h,0, arcAngle);
    
  }
  
  
  
  public void ChangeAngle(float angles){
    arcAngle= angles;
  }
  
   public void translate(float newx, float newy){
 
    shapeStartPoint.x += newx;
    shapeStartPoint.y += newy;
    
    shapeEndPoint.x += newx;
    shapeEndPoint.y += newy;

  }
  
  public void translate(float i){
 
    shapeStartPoint.x -= i;
    shapeStartPoint.y -= i;
    
    shapeEndPoint.x += i;
    shapeEndPoint.y += i;

  }

  void setSelectedDrawingStyle() {
    strokeWeight(lineThickness + 1);
    stroke(255, 0, 0);
    fill(255, 100, 100);
    
  }

  void setDefaultDrawingStyle() {
    strokeWeight(lineThickness);
    stroke(fillColor);
    fill(fillColor);
  }
  
   public void changeCholor(color newColor){
    fillColor = newColor;
  }
  
  public void ChangeStroke(int Stroke){
    lineThickness = Stroke;
  }
}     // end DrawnShape




////////////////////////////////////////////////////////////////////
// DrawingList Class
// this class stores all the drawn shapes during and after thay have been drawn
//
// 


class DrawingList {

  ArrayList<DrawnShape> shapeList = new ArrayList<DrawnShape>();

  // this references the currently drawn shape. It is set to null
  // if no shape is currently being drawn
  public DrawnShape currentlyDrawnShape = null;

  public DrawingList() {
  }
  
  public void drawMe() {
    for (DrawnShape s : shapeList) {
      s.drawMe();
    }
  }

  //delete selected objects
  public void tryDelete(){
    for(DrawnShape s : shapeList){
      if(s.isSelected){
        shapeList.remove(s);
                s.drawMe();
        break;
       }
     }
   }
   
  //delete selected objects
  public void fillShape(color theColor){
    for(DrawnShape s : shapeList){
      if(s.isSelected){
        s.changeCholor(theColor);
        break;
       }
     }
   }
   
     public void lineWeight(int lineValue){
    for(DrawnShape s : shapeList){
      if(s.isSelected){
        s.ChangeStroke(lineValue);
       }
     }
   }
   

   //public void tryUndo(PImage NewImage, PImage original){
   //  NewImage = original;
   //}
 
  public void handleMouseDrawEvent(String shapeType, String mouseEventType, PVector mouseLoc) {

    if ( mouseEventType.equals("mousePressed")) {
      DrawnShape newShape = new DrawnShape(shapeType);
      newShape.startMouseDrawing(mouseLoc);
      shapeList.add(newShape);
      currentlyDrawnShape = newShape;
    }

    if ( mouseEventType.equals("mouseDragged")) {
      currentlyDrawnShape.duringMouseDrawing(mouseLoc);
    }

    if ( mouseEventType.equals("mouseReleased")) {
      currentlyDrawnShape.endMouseDrawing(mouseLoc);
    }
  }
  

  public void trySelect(String mouseEventType, PVector mouseLoc) {
    if( mouseEventType.equals("mousePressed")){
      for (DrawnShape s : shapeList) {
        boolean selectionFound = s.tryToggleSelect(mouseLoc);
        if (selectionFound) 
        break;
      }
    }
  }
  
      public void tryMove(String mouseEventType, PVector mouseLoc) {
    if( mouseEventType.equals("mousePressed") || mouseEventType.equals("mouseDragged")){
      for (DrawnShape s : shapeList) {
        boolean selectionFound = s.tryToggleSelect(mouseLoc);
        if (selectionFound)
        s.translate(mouseX -s.shapeStartPoint.x, mouseY -s.shapeStartPoint.y);
        s.drawMe();
      }
    }
  }
  
  
    public void tryScale(String mouseEventType, PVector mouseLoc, float slidervalue) {
      for (DrawnShape s : shapeList) {
        boolean selectionFound = s.tryToggleSelect(mouseLoc);
        if (selectionFound)
        s.translate(slidervalue);
        s.drawMe();
      }
    }
 


public void ChangeAngle(float angle){
    for (DrawnShape s: shapeList){
      if(s.isSelected){
        s.ChangeAngle(angle);
  }
}
}
  

  boolean isBetweenInc(float v, float lo, float hi){
  if(v >= lo && v <= hi) return true;
  return false;
  }

float[][] edge_matrix = { { 0,  -2,  0 },
                          { -2,  8, -2 },
                          { 0,  -2,  0 } }; 
                     
float[][] blur_matrix = {  {0.1,  0.1,  0.1 },
                           {0.1,  0.1,  0.1 },
                           {0.1,  0.1,  0.1 } };                      

float[][] sharpen_matrix = {  { 0, -1, 0 },
                              {-1, 5, -1 },
                              { 0, -1, 0 } };  
                         
float[][] gaussianblur_matrix = { { 0.000,  0.000,  0.001, 0.001, 0.001, 0.000, 0.000},
                                  { 0.000,  0.002,  0.012, 0.020, 0.012, 0.002, 0.000},
                                  { 0.001,  0.012,  0.068, 0.109, 0.068, 0.012, 0.001},
                                  { 0.001,  0.020,  0.109, 0.172, 0.109, 0.020, 0.001},
                                  { 0.001,  0.012,  0.068, 0.109, 0.068, 0.012, 0.001},
                                  { 0.000,  0.002,  0.012, 0.020, 0.012, 0.002, 0.000},
                                  { 0.000,  0.000,  0.001, 0.001, 0.001, 0.000, 0.000}
                                  };


color convolution(int x, int y, float[][] matrix, int matrixsize, PImage img)
{
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  for (int i = 0; i < matrixsize; i++){
    for (int j= 0; j < matrixsize; j++){
      // What pixel are we testing
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + img.width*yloc;
      // Make sure we haven't walked off our image, we could do better here
      loc = constrain(loc,0,img.pixels.length-1);
      // Calculate the convolution
      rtotal += (red(img.pixels[loc]) * matrix[i][j]);
      gtotal += (green(img.pixels[loc]) * matrix[i][j]);
      btotal += (blue(img.pixels[loc]) * matrix[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Return the resulting color
  return color(rtotal, gtotal, btotal);
}

int[] create_contrast_lut(float contrast_modifier){
  int[] lut = new int[256];
  for(int n = 0; n < 256; n++) {

    float p = n/255.0f;  // p ranges between 0...1
    float val = sigmoidCurve(p, contrast_modifier);
    lut[n] = (int)(val*255);
  }
  return lut;
}

float sigmoidCurve(float v, float contrast_modifier){
  // contrast: generate a sigmoid function

  float f =  (1.0 / (1 + exp(-12 * (v  - contrast_modifier))));

 
  return f;
}

public void adjust_contrast(int[] lut){
  for (int y = 0; y < imageHeight; y++) {
      for (int x = 0; x < imageWidth; x++){


        color thisPix = outputImage.get(x,y);
        int r = (int)red(thisPix);
        int g = (int)green(thisPix);
        int b = (int)blue(thisPix);


        r = lut[r];
        g = lut[g];
        b = lut[b];


        color new_colour = color(r,g,b);

        outputImage.set(x,y, new_colour);

      }

    }
}

float changeBrightness(float v, float brightnessLevel){
  
  return v*brightnessLevel;
}

float contrast(float v, float contrastLevel){
  // contrast

  float f = 1.0 / (1 + exp(contrastLevel * (v  - 0.5))); //contrastUp
  //float f = 1.0 / (1 + exp(-8 * (v  - 0.5))); //contrastDown
  
 
  return f;
}


PImage applyPointProcessing(int[] redLUT, int[] greenLUT, int[] blueLUT, PImage inputImage){
  PImage outputImage = createImage(inputImage.width,inputImage.height,RGB);
  
  
  inputImage.loadPixels();
  outputImage.loadPixels();
  int numPixels = inputImage.width*inputImage.height;
  for(int n = 0; n < numPixels; n++){
    
    color c = inputImage.pixels[n];
    
    int r = (int)red(c);
    int g = (int)green(c);
    int b = (int)blue(c);
    
    r = redLUT[r];
    g = greenLUT[g];
    b = blueLUT[b];
    
    outputImage.pixels[n] = color(r,g,b);
    
    
  }
  
  return outputImage;
}

float[] RGBtoHSV(float r, float g, float b){
  
  
  float minRGB = min( r, g, b );
  float maxRGB = max( r, g, b );
    
    
  float value = maxRGB/255.0; 
  float delta = maxRGB - minRGB;
  float hue = 0;
  float saturation;
  
  float[] returnVals = {0f,0f,0f};
  

   if( maxRGB != 0 ) {
    // saturation is the difference between the smallest R,G or B value, and the biggest
      saturation = delta / maxRGB; }
   else { // it’s black, so we don’t know the hue
       return returnVals;
       }
       
  if(delta == 0){ 
         hue = 0;
        }
   else {
    // now work out the hue by finding out where it lies on the spectrum
      if( b == maxRGB ) hue = 4 + ( r - g ) / delta;   // between magenta, blue, cyan
      if( g == maxRGB ) hue = 2 + ( b - r ) / delta;   // between cyan, green, yellow
      if( r == maxRGB ) hue = ( g - b ) / delta;       // between yellow, Red, magenta
    }
  // the above produce a hue in the range -6...6, 
  // where 0 is magenta, 1 is red, 2 is yellow, 3 is green, 4 is cyan, 5 is blue and 6 is back to magenta 
  // Multiply the above by 60 to give degrees
   hue = hue * 60;
   if( hue < 0 ) hue += 360;
   
   returnVals[0] = hue;
   returnVals[1] = saturation;
   returnVals[2] = value;
   
   return returnVals;
}





// HSV to RGB
//
//
// expects values in range hue = [0,360], saturation = [0,1], value = [0,1]
color HSVtoRGB(float hue, float sat, float val)
{
  
    hue = hue/360.0;
    int h = (int)(hue * 6);
    float f = hue * 6 - h;
    float p = val * (1 - sat);
    float q = val * (1 - f * sat);
    float t = val * (1 - (1 - f) * sat);

    float r,g,b;


    switch (h) {
      case 0: r = val; g = t; b = p; break;
      case 1: r = q; g = val; b = p; break;
      case 2: r = p; g = val; b = t; break;
      case 3: r = p; g = q; b = val; break;
      case 4: r = t; g = p; b = val; break;
      case 5: r = val; g = p; b = q; break;
      default: r = val; g = t; b = p;
    }
    
    return color(r*255,g*255,b*255);
}
}
