const STDOUT = std.io.getStdOut().writer();
const JUMPS: []const usize = &.{ 16, 32, 0, 0, 0, 0 };
var ram: [66]u8 = undefined;

const Printer = struct {
    text: ?[]const u8 = "._.",
    fn writeTextOrNumber(this: Printer, number: []const u8) !void {
        try STDOUT.writeAll(this.text orelse number);
        return STDOUT.writeAll("\n");
    }
};

pub fn main() !void {
    var fba = std.heap.FixedBufferAllocator.init(&ram);
    const alloc = fba.allocator();
    const printer = try alloc.create(Printer);
    @memset(&ram, 0);
    (try alloc.create(Printer)).text = "fizz";
    (try alloc.create(Printer)).text = "buzz";
    (try alloc.create(Printer)).text = "fizzbuzz";
    for (1..101) |i| {
        std.mem.copyForwards(
            u8,
            &ram,
            ram[JUMPS[2 * @mod(i, 3)]..][JUMPS[1 + @mod(i, 5)]..][0..16],
        );
        var fbb = fba;
        const number = std.fmt.allocPrint(fbb.allocator(), "{d}", .{i}) catch "o_o";
        try printer.writeTextOrNumber(number);
        printer.text = null;
    }
}

const std = @import("std");
