public class PointBounds {
    public float minX;
    public float minY;
    public float maxX;
    public float maxY;

    public float minX() {
        return minX;
    }

    public float minY() {
        return minY;
    }

    public float maxX() {
        return maxX;
    }

    public float maxY() {
        return maxY;
    }

    public PVector bottomLeft() {
        return new PVector(minX, minY);
    }

    public PVector bottomRight() {
        return new PVector(minX, maxY);
    }

    public PVector topLeft() {
        return new PVector(maxX, minY);
    }

    public PVector topRight() {
        return new PVector(maxX, maxY);
    }

    public PointBounds(float minX, float minY, float maxX, float maxY) {
        this.minX = minX;
        this.minY = minY;
        this.maxX = maxX;
        this.maxY = maxY;
    }
}
