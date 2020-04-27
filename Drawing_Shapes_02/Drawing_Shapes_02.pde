// Example programme showing the SimpleUIManager (declared in the SimpleUI_Classes tab)
// This is for version 1, where only Menus and Simple Buttons are possible
//
//
//
PImage myImage;
PImage outputImage;
PImage mySecondImage;
color theColor;

SimpleUI myUI;
DrawingList drawingList;

String toolMode = "";
String[] menu1Items =  { "Black&White", "Grey", "Inverse", "Blur", "Sharpen", "Edge","GaussianBlur" };
int imageWidth;
int imageHeight;
int newImageWidth;
int NewIimageHeight;
String fileName;

void settings() {
  size(680,640);
  //surface.setResizable(true);
  
      mySecondImage = loadImage("ColourMap.png");
      
  myUI = new SimpleUI();
  drawingList = new DrawingList();
  
  myUI.addPlainButton("load IMG", 5,0);
  myUI.addPlainButton("save IMG", 5,35);

  ButtonBaseClass  rectButton = myUI.addRadioButton("draw rect", 5, 70, "group1");
  myUI.addRadioButton("draw circle", 5, 105, "group1");
  myUI.addRadioButton("draw line", 5, 140, "group1");
  myUI.addRadioButton("draw arc", 5, 175, "group1");
  
  myUI.addRadioButton("select", 5, 210, "group1");
  
  myUI.addPlainButton("Delete", 5, 280);
  
  myUI.addSlider("Brightness", 85, 565);
  
  myUI.addSlider("RGB", 85, 600);
  
  myUI.addSlider("Contrast", 200, 565);
  
  myUI.addSlider("Arc Angle", 200, 600);
  
  myUI.addPlainButton("Colour Picker", 310, 565);
  
  myUI.addPlainButton("Fill", 430, 565);
  
  myUI.addSlider("Line Weight", 510, 565);
  
  myUI.addSlider("Scale Shape", 510, 600);
  
  myUI.addRadioButton("Move", 5, 245,"group1");
  
  myUI.addPlainButton("Quit", 5, 600);
  
  myUI.addMenu("Image Manipulation", 5, 315, menu1Items);
  
  // set the current mode to "draw rect"
  //rectButton.selected = true;
  
  toolMode = rectButton.UILabel;

  //Size of Canvas
  myUI.addCanvas(80,0,600,560);
  
}

void draw() {
 background(255);
 
   
  // and draw your content afterwrds
  if( myImage != null ){
    image(myImage,80,0);
  }
 
  if(outputImage != null){
    image(outputImage, 80, 0);
  } 
 
   
  noStroke();
  fill(theColor);
  rect(390, 565, 30, 30);
 
 drawingList.drawMe();
 
 myUI.update();
}

// you MUST have this function declared.. it receives all the user-interface events
void handleUIEvent(UIEventData eventData){
  // here we just get the event to print its self
  // with "verbosity" set to 1, (1 = low, 3 = high, 0 = do not print anything)
  eventData.print(3);
  

  //////////////////////////////////////////////////
  // loading a file via the file dialog 
  //
  
  // this responds to the "load file" button and opens the file-load dialogue
  if(eventData.eventIsFromWidget("load IMG")){
    myUI.openFileLoadDialog("load an image");
  }
  
  //this catches the file load information when the file load dialogue's "open" button is hit
  if(eventData.eventIsFromWidget("fileLoadDialog")){
    myImage = loadImage(eventData.fileSelection);
    
    ////////////////////////////////////////////////////
    //resizing loaded images
    //storing image default width and height (Changes later)
    imageWidth = myImage.width;
    imageHeight = myImage.height;
    
    //While picture is bigger than canvas run this
    while ((imageWidth >= 600)||(imageHeight >= 600)){
      newImageWidth = ((imageWidth * 1) / 100); //1 percent of the images width
      NewIimageHeight = ((imageHeight * 1) / 100); //1 percent of the image height
      imageWidth = imageWidth - newImageWidth; //substract 1 percent from the previous image width 
      imageHeight = imageHeight - NewIimageHeight; //substract 1 percent from the previous image width 
    }
    //update New images width and height
    myImage.resize(imageWidth,imageHeight);
    //turns off the Draw Rect border
    myUI.setRadioButtonOff("group1");
  }
  
    //////////////////////////////////////////////////
  // saving a file via the file dialog 
  //
  
  // this responds to the "save file" button and opens the file-save dialogue
  if(eventData.eventIsFromWidget("save IMG")){
    myUI.openFileSaveDialog("save an image");
  }
  
  //this catches the file save information when the file save dialogue's "save" button is hit
  if(eventData.eventIsFromWidget("fileSaveDialog")){
    outputImage.save(eventData.fileSelection);
  }
  
  
  
    if (eventData.menuItem.equals("Black&White")) {
      outputImage = myImage.copy();
      outputImage.filter(THRESHOLD, 0.7);
    }
  
    if (eventData.menuItem.equals("Grey")) {
      outputImage = myImage.copy();
      outputImage.filter(GRAY);
    }
    
    if (eventData.menuItem.equals("Inverse")) {
      outputImage = myImage.copy();
      outputImage.filter(INVERT);;
    }
  
  if (eventData.menuItem.equals("Blur")) {
  
  outputImage = myImage.copy();
  myImage.loadPixels();
  
  int matrixSize = 3;
  for(int y = 0; y < imageHeight; y++){
    for(int x = 0; x < imageWidth; x++){
    
    color c = drawingList.convolution(x, y, drawingList.blur_matrix, matrixSize, myImage);
    
    outputImage.set(x,y,c);
    }
  }
}

  if (eventData.menuItem.equals("Sharpen")) {
  
  outputImage = myImage.copy();
  myImage.loadPixels();
  
  int matrixSize = 3;
  for(int y = 0; y < imageHeight; y++){
    for(int x = 0; x < imageWidth; x++){
    
    color c = drawingList.convolution(x, y, drawingList.sharpen_matrix, matrixSize, myImage);
    
    outputImage.set(x,y,c);
    }
  }
}

  if (eventData.menuItem.equals("Edge")) {
  
  outputImage = myImage.copy();
  myImage.loadPixels();
  
  int matrixSize = 3;
  for(int y = 0; y < imageHeight; y++){
    for(int x = 0; x < imageWidth; x++){
    
    color c = drawingList.convolution(x, y, drawingList.edge_matrix, matrixSize, myImage);
    
    outputImage.set(x,y,c);
    }
  }
}

  if (eventData.menuItem.equals("GaussianBlur")) {
  
  outputImage = myImage.copy();
  myImage.loadPixels();
  
  int matrixSize = 7;
  for(int y = 0; y < imageHeight; y++){
    for(int x = 0; x < imageWidth; x++){
    
    color c = drawingList.convolution(x, y, drawingList.gaussianblur_matrix, matrixSize, myImage);
    
    outputImage.set(x,y,c);
    }
  }
}

  if(eventData.eventIsFromWidget("Arc Angle")){
        float newAngle = (float)(eventData.sliderValue*2*PI);
        drawingList.ChangeAngle(newAngle);
        println(newAngle);
      }
  
    if( toolMode.equals("Brightness") ) {
    
    outputImage = myImage.copy();
    //myImage.loadPixels();
    
    float SliderValue = myUI.getSliderValue("Brightness");
    //int brt = (int)(eventData.sliderValue * 255);
    System.out.println(SliderValue);
    
    
        int[] lut = new int[256];
        for(int n = 0; n < 256; n++) {
          
          float px = n/255.0f;  // p ranges between 0...1
          float val = drawingList.changeBrightness(px,SliderValue);
          lut[n] = (int)(val*255);
        }
        outputImage = drawingList.applyPointProcessing(lut,lut,lut, myImage);
        outputImage.loadPixels();
   }
   
        if( toolMode.equals("Contrast") ) {
    
          outputImage = myImage.copy();
          //myImage.loadPixels();
          
          float SliderValue = myUI.getSliderValue("Contrast");
          SliderValue = SliderValue * -10;
          System.out.println(SliderValue);
          
              int[] lut = new int[256];
              for(int n = 0; n < 256; n++) {
                
                float v = n/255.0f;  // p ranges between 0...1
                float val = drawingList.contrast(v,SliderValue);
                lut[n] = (int)(val*255);
              }
            outputImage = drawingList.applyPointProcessing(lut,lut,lut, myImage);
            outputImage.loadPixels();
   }
    
   if( toolMode.equals("RGB") ) {
     
     outputImage = myImage.copy();
     
    float RGBSliderValue = myUI.getSliderValue("RGB");
    System.out.println(RGBSliderValue);
          
     for (int y = 0; y < imageHeight; y++) {
       for (int x = 0; x < imageWidth; x++){
        
        color thisPix = myImage.get(x,y);
        int r = (int) (red(thisPix));
        int g = (int) (green(thisPix));
        int b = (int) (blue(thisPix));
        
        float[] hsv = drawingList.RGBtoHSV(r,g,b);
        float hue = hsv[0];
        float sat = hsv[1];
        float val = hsv[2];

        hue += RGBSliderValue * 300;
        if( hue < 0 ) hue += 360;
        if( hue > 360 ) hue -= 360;
        
        color newRGB =  drawingList.HSVtoRGB(hue,  sat,  val);
        outputImage.set(x,y, newRGB);
       }   
     }
     
  }

  
  if( toolMode.equals("Line Weight") ) {
    int lineValue = (int)(myUI.getSliderValue("Line Weight") * 10);
    System.out.println(lineValue);
    drawingList.lineWeight(lineValue);
    
  }
  
  //?
  if(eventData.uiComponentType == "RadioButton"){
    toolMode = eventData.uiLabel;
    return;
  }
  
  //?
   if(eventData.uiComponentType.equals("ButtonBaseClass")){
    toolMode = eventData.uiLabel;
    return;
  }
  
  if(eventData.uiComponentType.equals("Slider")){
    toolMode = eventData.uiLabel;
    return;
  }
  
  

  // only canvas events below here!
  if(eventData.eventIsFromWidget("canvas")==false) return;
  PVector p =  new PVector(eventData.mousex, eventData.mousey);
  
  // this next line catches all the tool modes containing the word "draw"
  // so that drawing events are sent to the display list class only if the current tool 
  // is a drawing tool
  if( toolMode.contains("draw") ) {    
     drawingList.handleMouseDrawEvent(toolMode,eventData.mouseEventType, p);
  }
  
  if(toolMode.equals("Scale Shape")) {
    int ScaleSliderValue = ((int)(myUI.getSliderValue("Scale Shape") * 10)-5);
    System.out.println(ScaleSliderValue);
    drawingList.tryScale(eventData.mouseEventType, p, ScaleSliderValue);
  }

  
  if( toolMode.equals("Delete") ) {    
    drawingList.tryDelete();
    myUI.setRadioButtonOff("group1");
    }
    
  if( toolMode.equals("Move") ) {
    drawingList.tryMove(eventData.mouseEventType, p);
  }
  
  if( toolMode.equals("Fill") ) {    
    drawingList.fillShape(theColor);
    }
   
  // if the current tool is "select" then do this
  if( toolMode.equals("select") ) {   
       myUI.setMenusOff();
      drawingList.trySelect(eventData.mouseEventType, p);
    }
    
  if( toolMode.equals("Colour Picker") ) {
      String[] args = {"YourSketchNameHere"};
      ColourPicker sa = new ColourPicker();
      PApplet.runSketch(args, sa);
      toolMode = " ";
  }
    
   

    
  if( toolMode.equals("Quit") ) {    
     exit();
  }
  


}

public class ColourPicker extends PApplet {
 
  public void settings() {
    //load image into the PImage object, notice that the image is not yet drawn//
    imageWidth = mySecondImage.width;
    imageHeight = mySecondImage.height;
  size(imageWidth, imageHeight);
  }
  public void draw() {
    background(0);
    image(mySecondImage, 0, 0);
    //run the color picker function//
    pickColor();
  }
  
  void exit()
  {
    dispose();
  }
  
  void pickColor() {
  if (mousePressed == true) {
  //find the color under the mouse pointer//
  theColor = get(mouseX, mouseY);
  }
  //draw a box with the selected color//
  
  
};
}
