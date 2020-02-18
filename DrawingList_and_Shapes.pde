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
      }else{
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

  }

  void setSelectedDrawingStyle() {
    strokeWeight(2);
    stroke(0, 0, 0);
    fill(255, 100, 100);
    
  }

  void setDefaultDrawingStyle() {
    strokeWeight(1);
    stroke(0, 0, 0);
    fill(127, 127, 127);
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
        break;
       }
     }
   }
   
   public void tryUndo(PImage NewImage, PImage original){
     NewImage = original;
   }
   

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
}
