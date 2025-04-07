// linkedlist.zig

pub fn LinkedList(comptime T: type) type {
  return struct {
    first: ?*Node = null,
    last: ?*Node = null,
    len: usize = 0,
    
    const Self = @This();
    
    pub const Node = struct {
      prev: ?*Node = null,
      next: ?*Node = null,
      data: T,
    };
    
    pub fn push(self: *Self, new: *Node) void {
      self.len +=1;
      if (self.first) |f| {
        f.next = new;
        new.prev = f;
      }
      
      self.first = new;
      
      if (self.last == null) {
        self.last = new;
      }
    }

  }
}