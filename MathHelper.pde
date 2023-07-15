public class MathHelper {
    public PVector midPointOfLine(Point p1, Point p2) {
        float x = (p1.x() + p2.x()) / 2;
        float y = (p1.y() + p2.y()) / 2;
        return new PVector(x, y);
    }

    public float gradientOfLine(Point p1, Point p2) {
        return (p2.y() - p1.y()) / (p2.x() - p1.x());
    }

    public float negativeReciprocal(float value) {
        return -(1 / value);
    }

    // Returns the intersection point of two lines given the form Ax + By = C
    public PVector lineIntersection(float A1, float B1, float C1, float A2, float B2, float C2) {
        float delta = A1 * B2 - A2 * B1;
        if (delta == 0) {
            throw new IllegalArgumentException("Lines are parallel");
        }

        float x = (B2 * C1 - B1 * C2) / delta;
        float y = (A1 * C2 - A2 * C1) / delta;
        return new PVector(x, y);
    }
}
