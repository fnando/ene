require "test_helper"

class VersionTest < Minitest::Test
  test "initializes with components" do
    version = Ene::Version.new(0, 1, 2)

    assert_equal 0, version.major
    assert_equal 1, version.minor
    assert_equal 2, version.patch
  end

  test "returns individual components" do
    version = Ene::Version.parse("1.2.3")

    assert_equal 1, version.major
    assert_equal 2, version.minor
    assert_equal 3, version.patch
  end

  test "increments component" do
    version = Ene::Version.parse("0.0.0")

    assert_equal 0, version.major
    assert_equal 0, version.minor
    assert_equal 0, version.patch

    version.increment(:major)
    assert_equal 1, version.major
    assert_equal 0, version.minor
    assert_equal 0, version.patch

    version.increment(:minor)
    assert_equal 1, version.major
    assert_equal 1, version.minor
    assert_equal 0, version.patch

    version.increment(:patch)
    assert_equal 1, version.major
    assert_equal 1, version.minor
    assert_equal 1, version.patch
  end

  test "missing minor/patch" do
    assert_equal "0.0.0", Ene::Version.parse("0").to_s
    assert_equal "1.0.0", Ene::Version.parse("1").to_s
    assert_equal "2.0.0", Ene::Version.parse("2").to_s
  end

  test "missing patch" do
    assert_equal "0.1.0", Ene::Version.parse("0.1").to_s
    assert_equal "1.2.0", Ene::Version.parse("1.2").to_s
    assert_equal "2.3.0", Ene::Version.parse("2.3").to_s
  end

  test "all components specified" do
    assert_equal "0.1.2", Ene::Version.parse("0.1.2").to_s
    assert_equal "1.2.3", Ene::Version.parse("1.2.3").to_s
    assert_equal "2.3.4", Ene::Version.parse("2.3.4").to_s
  end

  test "expand */x" do
    assert_equal "0.0.0", Ene::Version.parse("*").to_s
    assert_equal "0.0.0", Ene::Version.parse("x").to_s
    assert_equal "0.0.0", Ene::Version.parse("0.x").to_s
    assert_equal "1.0.0", Ene::Version.parse("1.x").to_s
    assert_equal "1.2.0", Ene::Version.parse("1.2.x").to_s
  end
end
