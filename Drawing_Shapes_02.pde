// Example programme showing the SimpleUIManager (declared in the SimpleUI_Classes tab)
// This is for version 1, where only Menus and Simple Buttons are possible
//
//
//
PImage myImage;
PImage outputImage;
SimpleUI myUI;
DrawingList drawingList;

String toolMode = "";
String[] menu1Items =  { "Black&White", "Grey", "Inverse", "Blur", "Sharpen", "Edge","GaussianBlur", "Up Contrast","Down Contrast" };
int imageWidth;
int imageHeight;
int newImageWidth;
int NewIimageHeight;
String fileName;

void setup() {
  size(680,600);
  //surface.setResizable(true);
  
  
  myUI = new SimpleUI();
  drawingList = new DrawingList();
  
  myUI.addPlainButton("load file", 5,0);
  myUI.addPlainButton("save file", 5,35);

  ButtonBaseClass  rectButton = myUI.addRadioButton("draw rect", 5, 70, "group1");
  myUI.addRadioButton("draw circle", 5, 105, "group1");
  myUI.addRadioButton("draw line", 5, 140, "group1");
  
  myUI.addRadioButton("select", 5, 175, "group1");
  
  myUI.addPlainButton("Delete", 5, 210);
  
  myUI.addPlainButton("Undo", 5, 530);
  
  myUI.addPlainButton("Quit", 5, 565);
  
  myUI.addMenu("Image Manipulation", 5, 245, menu1Items);
  
  // set the current mode to "draw rect"
  rectButton.selected = true;
  
  toolMode = rectButton.UILabel;

  //Size of Canvas
  myUI.addCanvas(80,0,600,600);
  
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
 
 drawingList.drawMe();
 
 myUI.update();
}

// you MUST have this function declared.. it receives all the user-interface events
void handleUIEvent(UIEventData eventData){
  // here we just get the event to print its self
  // with "verbosity" set to 1, (1 = low, 3 = high, 0 = do not print anything)
  eventData.print(2);
  

  //////////////////////////////////////////////////
  // loading a file via the file dialog 
  //
  
  // this responds to the "load file" button and opens the file-load dialogue
  if(eventData.eventIsFromWidget("load file")){
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
  if(eventData.eventIsFromWidget("save file")){
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
    
    color c = convolution(x, y, blur_matrix, matrixSize, myImage);
    
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
    
    color c = convolution(x, y, sharpen_matrix, matrixSize, myImage);
    
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
    
    color c = convolution(x, y, edge_matrix, matrixSize, myImage);
    
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
    
    color c = convolution(x, y, gaussianblur_matrix, matrixSize, myImage);
    
    outputImage.set(x,y,c);
    }
  }
}

  if (eventData.menuItem.equals("Up Contrast")) {
     outputImage = myImage.copy();
     myImage.loadPixels();
     int[] up = create_contrast_lut(0.5);
     adjust_contrast(up); 
  }
 
  if (eventData.menuItem.equals("Down Contrast")) {
     outputImage = myImage.copy();
     myImage.loadPixels();
     int[] down = create_contrast_lut(0.4);
     adjust_contrast(down); 
  }
  //?
  if(eventData.uiComponentType.equals("RadioButton")){
    toolMode = eventData.uiLabel;
  }
  
  //?
   if(eventData.uiComponentType.equals("ButtonBaseClass")){
    toolMode = eventData.uiLabel;
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
  
  if( toolMode.equals("Delete") ) {    
    drawingList.tryDelete();
    myUI.setRadioButtonOff("group1");
    }
   
  // if the current tool is "select" then do this
  if( toolMode.equals("select") ) {   
       myUI.setMenusOff();
      drawingList.trySelect(eventData.mouseEventType, p);
    }
    
  if( toolMode.equals("Undo") ) {
    outputImage = myImage;
  }
    
  if( toolMode.equals("Quit") ) {    
     exit();
  }

}
