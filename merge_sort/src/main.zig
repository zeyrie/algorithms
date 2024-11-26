//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const std = @import("std");
const lib = @import("root.zig");
const debug = std.debug;

pub fn main() !void {
    var gpa_state = std.heap.GeneralPurposeAllocator(.{}){};
    var gpa = gpa_state.allocator();
    defer _ = gpa_state.deinit();

    // Create an arena allocator.
    var arena_allocator = std.heap.ArenaAllocator.init(gpa);
    const arena = arena_allocator.allocator();

    var values = std.process.args();

    // Skip the first argument (the executable name).
    _ = values.next();

    // Initialize an ArrayList using the arena allocator.
    var arr = std.ArrayList(u8).init(arena);
    // defer arr.deinit();

    while (values.next()) |arg| {
        const value = try std.fmt.parseInt(u8, arg, 10);
        try arr.append(value); // Dynamically add elements.
    }

    const slices = try arr.toOwnedSlice();

    // Use the ArrayList as needed.
    const final_arr = try lib.divide_list(&gpa, slices);
    debug.print("\nInput Array {any}\nSorted Array {any}", .{ slices, final_arr });
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // Try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "fuzz example" {
    const global = struct {
        fn testOne(input: []const u8) anyerror!void {
            // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!
            try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
        }
    };
    try std.testing.fuzz(global.testOne, .{});
}
