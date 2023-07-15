public class Point {
    private float X;
    private float Y;
    private float xoff = 0.0f;
    private float yoff = 0.0f;
    private float xinc = 0.001f;
    private float yinc = 0.001f;
    
    public float x() { return X; }
    public float y() { return Y; }
    public PVector pos() { return new PVector(X, Y); }
    
    public Point(float x, float y) {
        this.X = x;
        this.Y = y;
        this.setRandomOffsets();
    }
    
    public Point(Point point) {
        this.X = point.x();
        this.Y = point.y();
        this.setRandomOffsets();
    }
    
    public PVector getPos() {
        return this.pos();
    }
    
    public void setPosition(PVector pos) {
        this.X = pos.x;
        this.Y = pos.y;
    }
    
    public boolean equalsPoint(Point point) {
        return X == point.x() && Y == point.y();
    }
    
    public void setRandomOffsets() {
        this.xoff = random( -1,1);
        this.yoff = random( -1,1);
        this.xinc = random( -0.005, 0.005);
        this.yinc = random( -0.005, 0.005);
    }
    
    public void wander() {
        // move the point randomly using perlin noise such that they keep their original position but wander around it
        this.X = map(noise(this.xoff), 0, 1, this.X - 1, this.X + 1);
        this.Y = map(noise(this.yoff), 0, 1, this.Y - 1, this.Y + 1);
        this.xoff += this.xinc;
        this.yoff += this.yinc;
        
        // if off screen wrap around
        if (this.X < 0) this.X = width;
        if (this.X > width) this.X = 0;
        if (this.Y < 0) this.Y = height;
        if (this.Y > height) this.Y = 0;
    }
    
    @Override
    public String toString() {
        return "(" + X + ", " + Y + ")";
    }
}
