import std.algorithm;
import std.stdio;
import std.string;
import core.bitop: popcnt;

void main()
{
  int num1478 = 0;
  int outputSum = 0;
  foreach (string line; lines(stdin))
  {
    auto parts = line.split(" | ");
    parts[1] = parts[1].stripRight();

    num1478 += count!("!!a.length.among!(2, 3, 4, 7)")(parts[1].split(" "));

    //  seg 0
    // s     s
    // e     e
    // g     g
    // 1     2
    //  seg 3
    // s     s
    // e     e
    // g     g
    // 4     5
    //  seg 6
    // segment discovery:
    // 1, 4, 7, and 8 are unambiguously lengths 2, 4, 3, and 7
    // 2, 3, and 5 are length 5
    // 6, 9, and 0 are length 6
    //
    // segments is a bitmask for each digit, with bits 0 to 6 corresponding to wires a to g
    auto segments = new uint[10];
    parts = join([parts[0].split(" "), parts[1].split(" ")]);
    // 1, 4, and 7:
    auto allMasks = parts.map!(part => part.map!(c => (1u << (c - 'a'))).reduce!("a | b"));
    auto masks = allMasks[0 .. 10];
    auto outMasks = allMasks[10 .. $];
    foreach (uint mask; masks)
    {
      if (popcnt(mask) == 2) segments[1] = mask;
      if (popcnt(mask) == 4) segments[4] = mask;
      if (popcnt(mask) == 3) segments[7] = mask;
      if (popcnt(mask) == 7) segments[8] = mask;
    }
    // segments(1) ^ segments(4) -> (seg 1 | seg 3)
    // (seg 1 | seg 3) & (segments(6) & segments(9) & segments(0)) -> seg 1
    // seg 1 ^ (seg 1 | seg 3) -> seg 3
    int segs13 = segments[1] ^ segments[4];
    auto masks690 = masks.filter!(m => popcnt(m) == 6);
    int segs690and = masks690.reduce!("a & b");
    int seg1 = segs13 & segs690and;
    int seg3 = seg1 ^ segs13;
    // 0, 6 and 9:
    // of 6, 9, 0, only 0 has *no* seg 3
    // of 6, 9, only 9 has segments(1)
    foreach (uint mask; masks690)
    {
      if ((mask & seg3) == 0) {
        segments[0] = mask;
      } else if ((mask & segments[1]) == segments[1]) {
        segments[9] = mask;
      } else {
        segments[6] = mask;
      }
    }
    // 2, 3 and 5:
    // of 2, 3, 5, only 5 has seg 1
    // of 2, 3, only 3 has segments(1)
    foreach (uint mask; masks.filter!(m => popcnt(m) == 5))
    {
      if ((mask & seg1) != 0) {
        segments[5] = mask;
      } else if ((mask & segments[1]) == segments[1]) {
        segments[3] = mask;
      } else {
        segments[2] = mask;
      }
    }

    outputSum += outMasks.fold!((a, b) => a*10 + segments.countUntil(b))(0L);
  }

  writeln(num1478);
  writeln(outputSum);
}
