import { sort } from "./sort";

describe("sort", () => {
  it("should sort an array of numbers", () => {
    const input = [3, 2, 1];

    expect(sort(input)).toEqual([1, 2, 3]);
  });
});
