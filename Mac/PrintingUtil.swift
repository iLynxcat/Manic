@inlinable public func printing<ValueType: Any>(_ value: ValueType) -> ValueType
{
	debugPrint("\(value)")
	return value
}

@inlinable public func printing<ValueType: Any>(
	_ prefix: String = "", _ value: ValueType, _ suffix: String = ""
) -> ValueType {
	debugPrint("\(prefix)\(value)\(suffix)")
	return value
}
