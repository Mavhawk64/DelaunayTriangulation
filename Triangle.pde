public class Triangle {
    private PVector CircumCenter;
    private float CircumRadius;
    
    public Point[] vertices = new Point[3];
    
    public Point getVertA() { return vertices[0]; }
    public Point getVertB() { return vertices[1]; }
    public Point getVertC() { return vertices[2]; }
    public PVector getCircumCenter() { return CircumCenter; }
    public float getCircumRadius() { return CircumRadius; }
    
    public Triangle(Point pointA, Point pointB, Point pointC) {
        boolean isCounterClockwise = isCounterClockwise(pointA, pointB, pointC);
        
        vertices[0] = pointA;
        vertices[1] = isCounterClockwise ? pointB : pointC;
        vertices[2] = isCounterClockwise ? pointC : pointB;
        
        CircumCenter = computeCircumCenter();
        CircumRadius = computeCircumRadius();
    }
    
    public Edge[] getEdges() {
        return new Edge[] {
            new Edge(getVertA(), getVertB()),
                new Edge(getVertB(), getVertC()),
                new Edge(getVertA(), getVertC())
            };
    }
    
    // Returns true if the provided points are in counter clockwise orientation, false if clockwise
    private boolean isCounterClockwise(Point pointA, Point pointB, Point pointC) {
        float result = (pointB.x() - pointA.x()) * (pointC.y() - pointA.y()) - (pointC.x() - pointA.x()) * (pointB.y() - pointA.y());
        return result > 0;
    }
    
    public boolean containsEdge(Edge edge) {
        int sharedVerts = 0;
        for (int i = 0; i < vertices.length; i++) {
            if (vertices[i].equalsPoint(edge.getVertexA()) || vertices[i].equalsPoint(edge.getVertexB())) {
                sharedVerts++;
            }
        }
        return sharedVerts == 2;
    }
    
    public PVector computeCircumCenter() {
        // Given that all vertices on a triangle must touch the outside of the CircumCircle.
        // We can deduce that DA = DB = DC (Distances from each vertex to the center are equal).
        // Formula reference - https://en.wikipedia.org/wiki/Circumscribed_circle#Circumcircle_equations
        
        PVector A = getVertA().getPos();
        PVector B = getVertB().getPos();
        PVector C = getVertC().getPos();
        PVector SqrA = new PVector(A.x * A.x, A.y * A.y);
        PVector SqrB = new PVector(B.x * B.x, B.y * B.y);
        PVector SqrC = new PVector(C.x * C.x, C.y * C.y);
        
        float D = (A.x * (B.y - C.y) + B.x * (C.y - A.y) + C.x * (A.y - B.y)) * 2;
        float x = ((SqrA.x + SqrA.y) * (B.y - C.y) + (SqrB.x + SqrB.y) * (C.y - A.y) + (SqrC.x + SqrC.y) * (A.y - B.y)) / D;
        float y = ((SqrA.x + SqrA.y) * (C.x - B.x) + (SqrB.x + SqrB.y) * (A.x - C.x) + (SqrC.x + SqrC.y) * (B.x - A.x)) / D;
        return new PVector(x, y);
    }
    
    public float computeCircumRadius() {
        // Radius is the distance from any vertex to the CircumCenter
        PVector circumCenter = computeCircumCenter();
        return PVector.dist(circumCenter, vertices[0].getPos());
    }
    
    public Point[] getVertices() {
        return this.vertices;
    }
    
    public void show() {
        push();
        stroke(255);
        strokeWeight(1);
        noFill();
        triangle(getVertA().getPos().x, getVertA().getPos().y, getVertB().getPos().x, getVertB().getPos().y, getVertC().getPos().x, getVertC().getPos().y);
        pop();
    }
    
    @Override
    public String toString() {
        return "Triangle{\n\tvertices=[" + this.getVertA() + ", " + this.getVertB() + ", " + this.getVertC() + "]\n" + "}";
    }
}
