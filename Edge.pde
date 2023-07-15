public class Edge {
    private Point VertexA;
    private Point VertexB;
    private PVector MidPoint;
    private float Gradient;
    private MathHelper mathHelper;

    public Point getVertexA() { return VertexA; }
    public Point getVertexB() { return VertexB; }
    public PVector getMidPoint() { return MidPoint; }
    public float getGradient() { return Gradient; }

    public Edge(Point vertexA, Point vertexB) {
        VertexA = vertexA;
        VertexB = vertexB;
        mathHelper = new MathHelper();
        MidPoint = mathHelper.midPointOfLine(VertexA, VertexB);
        Gradient = mathHelper.gradientOfLine(VertexA, VertexB);
    }

    public boolean equalsEdge(Edge edge) {
        return VertexA.pos().equals(edge.getVertexA().pos()) && VertexB.pos().equals(edge.getVertexB().pos());
    }
}
