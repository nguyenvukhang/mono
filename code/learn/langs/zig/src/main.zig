const std = @import("std");
const c = @cImport({
    @cInclude("small.c");
});

test "t01" {
    // [10]u8 casts to [*c]u8
    var buffer: [10]u8 = undefined;
    c.edit_string(&buffer);

    try std.testing.expectEqualStrings(buffer[0..5], "hello");
}

test "t02" {
    // If a C function expects a [*c][*c]u8, we just need to make a [*c]u8 to
    // catch it.
    var ptr: [*c]u8 = undefined;
    c.edit_string_arr(&ptr);
    try std.testing.expectEqualStrings(std.mem.span(ptr), "hello");
}
