"""Test fixture for node ability with edge entry trigger and separated impl."""

edge Link {}

node Container {
    can connect with Link entry;
}
