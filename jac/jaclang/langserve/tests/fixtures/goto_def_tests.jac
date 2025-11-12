node SomeNode {
    has some_attr: int;
}

walker SomeWalker {
    can with SomeNode entry {
        print(here); # <-- go to definition of here
        visit [-->(`?SomeNode:some_attr==10)];
    }
}
