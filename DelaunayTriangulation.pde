// My take on Unity code written here: https://github.com/ScottyRAnderson/Delaunay-Triangulation/tree/575f8fb98109b37c186432ae4b35fb3999c50ae0
// There are direct translations of the code but modified to fit Processing.
// Additions: Point movement -- follows a perlin noise field to wander around the screen and wrap around the edges.


int pointCount = 20;
private List<Point> Points = new ArrayList<Point>();
private boolean AlwaysRefresh = true;
private boolean AllowWandering = true;
private boolean DebugVerticies = true;
private boolean DebugEdges = true;
private boolean DebugCircumCircles = true;
private boolean DebugCircumCenters = true;
private boolean DebugSuperTriangle = true;
private boolean DebugBounds = true;
private float DebugScale = 0.2f;
private int PointDebugColor = color(255, 0, 0);
private int EdgeDebugColor = color(255, 255, 0);
private int CircumDebugColor = color(0, 255, 0);
private List<Triangle> Triangulation;
public List<Point> points() { return Points; }
public void AddPoint(PVector position) {
    Points.add(new Point(position.x, position.y));
}
public void SetPoints(List<Point> points) {
    Points = points;
}
public void ClearPoints() {
    Points.clear();
}

void setup() {
    size(800, 800);    
    for (int i = 0; i < pointCount; i++) {
        AddPoint(new PVector(random(width), random(height)));
    }
}

void draw() {
    if (AlwaysRefresh) {
        background(51);
        Triangulate();
        if (Triangulation != null && Triangulation.size() > 0)
            //println(Triangulate().size());
            for (Triangle t : Triangulation) {
                t.show();
            }
        drawPoints();
    }
}

void mouseClicked() {
    AddPoint(new PVector(mouseX, mouseY));
}

public void drawPoints() {
    push();
    stroke(255);
    strokeWeight(8);
    for (Point p : Points) {
        point(p.x(), p.y());
    }
    pop();
    
    if (AllowWandering) {
        for (Point p : Points) {
            p.wander();
        }
    }
}

public List<Triangle> Triangulate() {
    //println("Triangulating " + Points.size() + " points");
    if (Points.size() == 0) {
        return null;
    }
    DelaunayHelper dh = new DelaunayHelper();
    Triangulation = dh.delaun(Points);
    return Triangulation;
}
public void DebugTriangulationGizmos() {
    DelaunayHelper dh = new DelaunayHelper();
    if (Points.size() == 0) {
        return;
    }
    if (DebugVerticies) {
        for (int i = 0; i < Points.size(); i++) {
            Point point = Points.get(i);
            fill(PointDebugColor);
            noStroke();
            ellipse(point.x(), point.y(), DebugScale, DebugScale);
        }
    }
    if (Triangulation == null) {
        return;
    }
    for (int i = 0; i < Triangulation.size(); i++) {
        Triangle triangle = Triangulation.get(i);
        if (triangle.vertices == null) {
            continue;
        }
        if (DebugEdges) {
            stroke(EdgeDebugColor);
            for (int j = 0; j < triangle.vertices.length - 1; j++) {
                PVector v1 = triangle.vertices[j].pos();
                PVector v2 = triangle.vertices[j + 1].pos();
                line(v1.x, v1.y, v2.x, v2.y);
            }
            PVector lastVertex = triangle.vertices[triangle.vertices.length - 1].pos();
            PVector firstVertex = triangle.vertices[0].pos();
            line(lastVertex.x, lastVertex.y, firstVertex.x, firstVertex.y);
        }
        if (DebugCircumCircles) {
            noFill();
            stroke(CircumDebugColor);
            PVector center = triangle.CircumCenter;
            float radius = triangle.CircumRadius;
            ellipse(center.x, center.y, radius * 2, radius * 2);
        }
        if (DebugCircumCenters) {
            fill(CircumDebugColor);
            noStroke();
            PVector center = triangle.CircumCenter;
            ellipse(center.x, center.y, DebugScale, DebugScale);
        }
    }
    if (DebugSuperTriangle) {
        stroke(EdgeDebugColor);
        Triangle superTriangle = dh.generateSuperTriangle(dh.getPointBounds(Points));
        for (int i = 0; i < superTriangle.vertices.length - 1; i++) {
            PVector v1 = superTriangle.vertices[i].pos();
            PVector v2 = superTriangle.vertices[i + 1].pos();
            line(v1.x, v1.y, v2.x, v2.y);
        }
        PVector lastVertex = superTriangle.vertices[superTriangle.vertices.length - 1].pos();
        PVector firstVertex = superTriangle.vertices[0].pos();
        line(lastVertex.x, lastVertex.y, firstVertex.x, firstVertex.y);
    }
    if (DebugBounds) {
        stroke(color(0, 255, 255));
        PointBounds bounds = dh.getPointBounds(Points);
        line(bounds.bottomLeft().x, bounds.bottomLeft().y, bounds.bottomRight().x, bounds.bottomRight().y);
        line(bounds.bottomRight().x, bounds.bottomRight().y, bounds.topRight().x, bounds.topRight().y);
        line(bounds.topRight().x, bounds.topRight().y, bounds.topLeft().x, bounds.topLeft().y);
        line(bounds.topLeft().x, bounds.topLeft().y, bounds.bottomLeft().x, bounds.bottomLeft().y);
    }
}
