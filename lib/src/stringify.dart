String mapPropsToString(Type runtimeType, List<Object?> props) =>
    '$runtimeType${props.map((prop) => prop?.toString() ?? '')}';
