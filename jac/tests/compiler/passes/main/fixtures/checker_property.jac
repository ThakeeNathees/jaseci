import from typing { Any }

obj Foo {
    @property
    def bar()  -> str {
        return "Hello, World!";
    }

    def ba()  -> int {
        return 42;
    }
}

with entry {
    foo = Foo();
    b: str = foo.bar;  # <-- Ok (No error)
}
