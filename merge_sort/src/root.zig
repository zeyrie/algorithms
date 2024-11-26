//! This library will implement the Merge Sort algorithm, this is a part of my learning exercises for both the zig langugage as well as the
//! algorithm concepts
//!
//! The Pseudocode for this method is as follows:
//!
//! MergeSort
//!      Input: array A of n distinct integers.
//!      Output: array with the same integers, sorted from
//!      smallest to largest.
//!      ----------------------------------------------------
//!      // ignoring base cases
//!      C := recursively sort first half of A
//!      D := recursively sort second half of A
//!      return Merge (C,D)
//!

const std = @import("std");
const debug = std.debug;
const testing = std.testing;

// First we will handle te divide the array into two parts
pub fn divide_list(alc: *std.mem.Allocator, arr: []u8) ![]u8 {
    const len = arr.len;

    if (len < 2) {
        return arr;
    }

    const left: usize = len / 2;
    const right = len - left;

    const lower = arr[0..left];
    const higher = arr[(left)..len];

    var left_arr = try divide_list(alc, lower);
    var right_arr = try divide_list(alc, higher);

    return try merge_arrs(alc, &left_arr, &right_arr, left, right);
}

fn merge_arrs(alc: *std.mem.Allocator, left: *[]u8, right: *[]u8, left_len: usize, right_len: usize) ![]u8 {
    var i: u8 = 0;
    var j: u8 = 0;

    const total_len = left_len + right_len;

    var arena_state = std.heap.ArenaAllocator.init(alc.*);
    const arena = arena_state.allocator();

    var final_arr = try arena.alloc(u8, total_len);

    errdefer alc.free(final_arr);

    for (0..total_len) |k| {
        if (i >= left_len) {
            var x = k;
            while (j < right_len) {
                final_arr[x] = right.*[j];
                j += 1;
                x += 1;
            }
            break;
        }
        if (j >= right_len) {
            var x = k;
            while (i < left_len) {
                final_arr[x] = left.*[i];
                i += 1;
                x += 1;
            }
            break;
        }
        if (left.*[i] < right.*[j]) {
            final_arr[k] = left.*[i];
            i += 1;
        } else {
            final_arr[k] = right.*[j];
            j += 1;
        }
    }

    return final_arr;
}

test "test simple" {
    try testing.expect(true);
}
