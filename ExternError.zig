pub fn ExternError(comptime E: type, comptime T: type) type {
    return extern struct {
        const Self = @This();

        isError: bool,
        errorInt: @import("std").meta.Int(.unsigned, @bitSizeOf(E)) = 0,
        value: T = undefined,

        pub fn initError(err: E) Self {
            return .{
                .isError = true,
                .errorInt = @intFromError(err),
            };
        }
        pub fn initValue(v: T) Self {
            return .{
                .isError = false,
                .value = v,
            };
        }

        pub fn getValue(self: Self) E!T {
            return if (self.isError) @as(E, @errorCast(@errorFromInt(self.errorInt))) else self.value;
        }
    };
}
