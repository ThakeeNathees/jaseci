
include import_star;

obj X{}

with entry {
    a :X = X();

    x: str = Foo().foo();
    y: int = Bar().bar();
}
