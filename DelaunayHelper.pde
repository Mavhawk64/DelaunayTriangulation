import java.util.ArrayList;
import java.util.List;

public class DelaunayHelper {
    private  final float Margin = 3f;

    /**
     * Generates a 'Super Triangle' which encompasses all points held within set bounds.
     */
    public Triangle generateSuperTriangle(PointBounds bounds) {
        float dMax = Math.max(bounds.maxX - bounds.minX, bounds.maxY - bounds.minY) * Margin;
        float xCen = (bounds.minX + bounds.maxX) * 0.5f;
        float yCen = (bounds.minY + bounds.maxY) * 0.5f;

        // The float 0.866 is an arbitrary value determined for optimum super triangle conditions.
        float x1 = xCen - 0.866f * dMax;
        float x2 = xCen + 0.866f * dMax;
        float x3 = xCen;

        float y1 = yCen - 0.5f * dMax;
        float y2 = yCen - 0.5f * dMax;
        float y3 = yCen + dMax;

        Point pointA = new Point(x1, y1);
        Point pointB = new Point(x2, y2);
        Point pointC = new Point(x3, y3);

        return new Triangle(pointA, pointB, pointC);
    }

    /**
     * Returns a set of bounds enclosing a point set.
     */
    public PointBounds getPointBounds(List<Point> points) {
        float minX = Float.POSITIVE_INFINITY;
        float minY = Float.POSITIVE_INFINITY;
        float maxX = Float.NEGATIVE_INFINITY;
        float maxY = Float.NEGATIVE_INFINITY;

        for (Point p : points) {
            if (minX > p.x()) {
                minX = p.x();
            }
            if (minY > p.y()) {
                minY = p.y();
            }
            if (maxX < p.x()) {
                maxX = p.x();
            }
            if (maxY < p.y()) {
                maxY = p.y();
            }
        }
        return new PointBounds(minX, minY, maxX, maxY);
    }

    /**
     * Triangulates a set of points utilizing the Bowyer Watson Delaunay technique.
     */
    public  List<Triangle> delaun(List<Point> points) {
        // TODO - Plenty of optimizations for this algorithm to be implemented
        List<Point> copyPoints = new ArrayList<>(points);

        // Create an empty triangle list
        List<Triangle> triangles = new ArrayList<>();

        // Generate super triangle to encompass all points and add it to the empty triangle list
        PointBounds bounds = getPointBounds(copyPoints);
        Triangle superTriangle = generateSuperTriangle(bounds);
        triangles.add(superTriangle);

        // Loop through points and carry out the triangulation
        for (int pIndex = 0; pIndex < copyPoints.size(); pIndex++) {
            Point p = copyPoints.get(pIndex);
            List<Triangle> badTriangles = new ArrayList<>();

            // Identify 'bad triangles'
            for (int triIndex = triangles.size() - 1; triIndex >= 0; triIndex--) {
                Triangle triangle = triangles.get(triIndex);

                // A 'bad triangle' is defined as a triangle whose CircumCenter contains the current point
                float dist = p.pos().dist(triangle.CircumCenter);
                if (dist < triangle.CircumRadius) {
                    badTriangles.add(triangle);
                }
            }

            // Construct a polygon from unique edges, i.e. ignoring duplicate edges inclusively
            List<Edge> polygon = new ArrayList<>();
            for (int i = 0; i < badTriangles.size(); i++) {
                Triangle triangle = badTriangles.get(i);
                Edge[] edges = triangle.getEdges();

                for (Edge edge : edges) {
                    boolean rejectEdge = false;
                    for (int t = 0; t < badTriangles.size(); t++) {
                        if (t != i && badTriangles.get(t).containsEdge(edge)) {
                            rejectEdge = true;
                            break;
                        }
                    }

                    if (!rejectEdge) {
                        polygon.add(edge);
                    }
                }
            }

            // Remove bad triangles from the triangulation
            triangles.removeAll(badTriangles);

            // Create new triangles
            for (Edge edge : polygon) {
                Point pointA = new Point(p.x(), p.y());
                Point pointB = new Point(edge.getVertexA());
                Point pointC = new Point(edge.getVertexB());
                triangles.add(new Triangle(pointA, pointB, pointC));
            }
        }

        // Finally, remove all triangles which share vertices with the super triangle
        triangles.removeIf(triangle -> {
            for (Point vertex : triangle.getVertices()) {
                for (Point superVertex : superTriangle.getVertices()) {
                    if (vertex.equalsPoint(superVertex)) {
                        return true;
                    }
                }
            }
            return false;
        });

        return triangles;
    }

    //public  Mesh createMeshFromTriangulation(List<Triangle> triangulation) {
    //    int vertexCount = triangulation.size() * 3;

    //    float[] vertices = new float[vertexCount * 2];
    //    float[] uvs = new float[vertexCount * 2];
    //    int[] triangles = new int[vertexCount];

    //    int vertexIndex = 0;
    //    int triangleIndex = 0;
    //    for (Triangle triangle : triangulation) {
    //        vertices[vertexIndex] = triangle.getVertA().x;
    //        vertices[vertexIndex + 1] = triangle.getVertA().y;

    //        vertices[vertexIndex + 2] = triangle.getVertB().x;
    //        vertices[vertexIndex + 3] = triangle.getVertB().y;

    //        vertices[vertexIndex + 4] = triangle.getVertC().x;
    //        vertices[vertexIndex + 5] = triangle.getVertC().y;

    //        uvs[vertexIndex] = triangle.getVertA().x;
    //        uvs[vertexIndex + 1] = triangle.getVertA().y;

    //        uvs[vertexIndex + 2] = triangle.getVertB().x;
    //        uvs[vertexIndex + 3] = triangle.getVertB().y;

    //        uvs[vertexIndex + 4] = triangle.getVertC().x;
    //        uvs[vertexIndex + 5] = triangle.getVertC().y;

    //        triangles[triangleIndex] = vertexIndex + 2;
    //        triangles[triangleIndex + 1] = vertexIndex + 1;
    //        triangles[triangleIndex + 2] = vertexIndex;

    //        vertexIndex += 6;
    //        triangleIndex += 3;
    //    }

    //    return new Mesh(vertices, uvs, triangles);
    //}
}
