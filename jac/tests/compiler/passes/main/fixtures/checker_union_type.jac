with entry {
    x: int | None = 42;  # <-- Ok
    y: str | None = 3.14;  # <-- Error

    union_of_union_1: None | str | int = 1;  # <-- Ok
    union_of_union_2: None | float | int = "";  # <-- Error
}
