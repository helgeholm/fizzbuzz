const std = @import("std");

inline fn fb(n: comptime_int) []const u8 {
    if (n > 100) return "";
    return switch (n % 15) {
        3, 6, 9, 12 => "fizz\n",
        5, 10 => "buzz\n",
        0 => "fizzbuzz\n",
        else => std.fmt.comptimePrint("{d}\n", .{n}),
    } ++ fb(n + 1);
}

pub fn main() !void {
    try std.io.getStdOut().writer().writeAll(fb(1));
}
