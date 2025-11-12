

node SomeNode { }

walker SomeWalker {
    can with `root entry {
        visit [-->(`?SomeNode)];
    }
}
