cl import from .button { CustomButton }

cl def RelativeImport()  -> Any {
    return <div>
        <CustomButton />
    </div>;
}

cl def app()  -> Any {
    return <RelativeImport />;
}
