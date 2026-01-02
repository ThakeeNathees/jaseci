with entry {
    x: int = 42;
    y: float = 3.14;
    z: float = x + y;  # int + float should work and return float
    w: float = y + x;  # float + int should work and return float
}
