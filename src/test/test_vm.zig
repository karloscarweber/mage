const virtual_machine = @import("../vm.zig");
const MageVM = virtual_machine.MageVM;

const std = @import("std");
const builtin = @import("builtin");
const allocator = testing.allocator;
const testing = std.testing;
const print = std.debug.print;
const expect = testing.expect;

// TESTS
const test_string = "vm:init-deinit:";
test "vm:init-deinit" {
  var vm = MageVM.init(allocator);
  defer vm.deinit();
  
  expect(true) catch {
    print("{s}Something is amisss\n", .{test_string});
  };
  expect(5 == 6) catch {
    print("{s}5 == 6, is wrong\n", .{test_string});
  };
  expect(7 == 10) catch {
    print("{s}7 == 10, is wrong\n", .{test_string});
  };
}
