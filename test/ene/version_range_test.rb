require "test_helper"

class VersionRangeTest < Minitest::Test
  test "any version" do
    assert_equal [">=0.0.0"], Ene::VersionRange.parse("*")
    assert_equal [">=0.0.0"], Ene::VersionRange.parse("")
    assert_equal [">=0.0.0"], Ene::VersionRange.parse("x")
    assert_equal [">=0.0.0"], Ene::VersionRange.parse("x.x")
    assert_equal [">=0.0.0"], Ene::VersionRange.parse("x.x.x")

    assert_equal [">=0.0.0"], Ene::VersionRange.parse("^x")
    assert_equal [">=0.0.0"], Ene::VersionRange.parse("^x.0")
    assert_equal [">=0.0.0"], Ene::VersionRange.parse("^x.x")
    assert_equal [">=0.0.0"], Ene::VersionRange.parse("^x.1.0")

    assert_equal [">=0.0.0"], Ene::VersionRange.parse("~x")
    assert_equal [">=0.0.0"], Ene::VersionRange.parse("~x.0")
    assert_equal [">=0.0.0"], Ene::VersionRange.parse("~x.x")
    assert_equal [">=0.0.0"], Ene::VersionRange.parse("~x.1.0")

    assert_equal [">=0.0.0"], Ene::VersionRange.parse("=x")
    assert_equal [">=0.0.0"], Ene::VersionRange.parse("=x.0")
    assert_equal [">=0.0.0"], Ene::VersionRange.parse("=x.x")
    assert_equal [">=0.0.0"], Ene::VersionRange.parse("=x.1.0")

    assert_equal [">=0.0.0"], Ene::VersionRange.parse(">=x")
    assert_equal [">=0.0.0"], Ene::VersionRange.parse(">=x.0")
    assert_equal [">=0.0.0"], Ene::VersionRange.parse(">=x.x")
    assert_equal [">=0.0.0"], Ene::VersionRange.parse(">=x.1.0")

    assert_equal [">=0.0.0"], Ene::VersionRange.parse("<=x")
    assert_equal [">=0.0.0"], Ene::VersionRange.parse("<=x.0")
    assert_equal [">=0.0.0"], Ene::VersionRange.parse("<=x.x")
    assert_equal [">=0.0.0"], Ene::VersionRange.parse("<=x.1.0")

    assert_equal ["<0.0.0"], Ene::VersionRange.parse(">x")
    assert_equal ["<0.0.0"], Ene::VersionRange.parse("<x")
    assert_equal ["<0.0.0"], Ene::VersionRange.parse(">x.0")
    assert_equal ["<0.0.0"], Ene::VersionRange.parse("<x.0")
    assert_equal ["<0.0.0"], Ene::VersionRange.parse(">x.0.1")
    assert_equal ["<0.0.0"], Ene::VersionRange.parse("<x.0.1")
    assert_equal ["<0.0.0"], Ene::VersionRange.parse("<x.x")
    assert_equal ["<0.0.0"], Ene::VersionRange.parse(">x.x")
  end

  test "caret" do
    assert_equal [">=0.0.0", "<1.0.0"], Ene::VersionRange.parse("^0")
    assert_equal [">=0.1.0", "<0.2.0"], Ene::VersionRange.parse("^0.1")
    assert_equal [">=0.1.2", "<0.2.0"], Ene::VersionRange.parse("^0.1.2")
    assert_equal [">=1.0.0", "<2.0.0"], Ene::VersionRange.parse("^1")
    assert_equal [">=1.2.0", "<2.0.0"], Ene::VersionRange.parse("^1.2")
    assert_equal [">=1.2.3", "<2.0.0"], Ene::VersionRange.parse("^1.2.3")

    assert_equal [">=0.0.0"], Ene::VersionRange.parse("^x")
    assert_equal [">=0.0.0", "<1.0.0"], Ene::VersionRange.parse("^0.x")
    assert_equal [">=0.1.0", "<0.2.0"], Ene::VersionRange.parse("^0.1.x")
    assert_equal [">=1.0.0", "<2.0.0"], Ene::VersionRange.parse("^1.x")
    assert_equal [">=1.2.0", "<2.0.0"], Ene::VersionRange.parse("^1.2.x")
  end

  test "tilde" do
    assert_equal [">=0.0.0", "<1.0.0"], Ene::VersionRange.parse("~0")
    assert_equal [">=0.1.0", "<0.2.0"], Ene::VersionRange.parse("~0.1")
    assert_equal [">=0.1.2", "<0.2.0"], Ene::VersionRange.parse("~0.1.2")
    assert_equal [">=1.0.0", "<2.0.0"], Ene::VersionRange.parse("~1")
    assert_equal [">=1.2.0", "<1.3.0"], Ene::VersionRange.parse("~1.2")
    assert_equal [">=1.2.3", "<1.3.0"], Ene::VersionRange.parse("~1.2.3")
  end

  test "ranges" do
    assert_equal [">=0.0.0", "<2.0.0"], Ene::VersionRange.parse("0 - 1")
    assert_equal [">=0.1.0", "<2.0.0"], Ene::VersionRange.parse("0.1 - 1")
    assert_equal [">=0.1.2", "<2.0.0"], Ene::VersionRange.parse("0.1.2 - 1")
    assert_equal [">=0.0.0", "<1.3.0"], Ene::VersionRange.parse("0 - 1.2")
    assert_equal [">=0.0.0", "<=1.2.3"], Ene::VersionRange.parse("0 - 1.2.3")
    assert_equal [">=1.0.0", "<2.0.0"], Ene::VersionRange.parse("1 - 1")
    assert_equal [">=1.0.0", "<1.3.0"], Ene::VersionRange.parse("1 - 1.2")
    assert_equal [">=1.0.0", "<=1.2.3"], Ene::VersionRange.parse("1 - 1.2.3")
  end

  test "x" do
    assert_equal [">=0.0.0", "<1.0.0"], Ene::VersionRange.parse("0.x")
    assert_equal [">=0.0.0", "<0.1.0"], Ene::VersionRange.parse("0.0.x")
    assert_equal [">=0.0.0", "<1.0.0"], Ene::VersionRange.parse("0.x.2")
    assert_equal [">=1.0.0", "<2.0.0"], Ene::VersionRange.parse("1.x")
    assert_equal [">=1.2.0", "<1.3.0"], Ene::VersionRange.parse("1.2.x")
    assert_equal [">=1.0.0", "<2.0.0"], Ene::VersionRange.parse("1.x.3")
  end

  test "exact version" do
    assert_equal [">=0.0.0", "<1.0.0"], Ene::VersionRange.parse("v0")
    assert_equal [">=0.0.0", "<1.0.0"], Ene::VersionRange.parse("=0")
    assert_equal [">=0.0.0", "<1.0.0"], Ene::VersionRange.parse("0")

    assert_equal [">=0.1.0", "<0.2.0"], Ene::VersionRange.parse("v0.1")
    assert_equal [">=0.1.0", "<0.2.0"], Ene::VersionRange.parse("=0.1")
    assert_equal [">=0.1.0", "<0.2.0"], Ene::VersionRange.parse("0.1")

    assert_equal [">=1.0.0", "<2.0.0"], Ene::VersionRange.parse("v1")
    assert_equal [">=1.0.0", "<2.0.0"], Ene::VersionRange.parse("=1")
    assert_equal [">=1.0.0", "<2.0.0"], Ene::VersionRange.parse("1")

    assert_equal [">=1.2.0", "<1.3.0"], Ene::VersionRange.parse("v1.2")
    assert_equal [">=1.2.0", "<1.3.0"], Ene::VersionRange.parse("=1.2")
    assert_equal [">=1.2.0", "<1.3.0"], Ene::VersionRange.parse("1.2")

    assert_equal ["1.2.3"], Ene::VersionRange.parse("v1.2.3")
    assert_equal ["1.2.3"], Ene::VersionRange.parse("=1.2.3")
    assert_equal ["1.2.3"], Ene::VersionRange.parse("1.2.3")
  end
end
