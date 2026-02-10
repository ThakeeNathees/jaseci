cl import from .components.button { CustomButton }
cl import from .button { CustomButtonRoot }

cl def RelativeImport -> Any {
    return
        <div>
            <CustomButton />
            <CustomButtonRoot />
        </div>;
}

cl def:pub app -> Any {
    return
        <RelativeImport />;
}
