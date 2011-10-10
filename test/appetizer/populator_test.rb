require "appetizer/test"
require "appetizer/populator"

class Appetizer::PopulatorTest < Appetizer::Test
  def test_initialize
    p = Appetizer::Populator.new :target, :source

    assert_equal :target, p.target
    assert_equal :source, p.source
  end

  def test_nested
    t2 = mock { expects(:bar=).with "baz" }

    t = mock do
      expects(:foo).returns t2
    end

    Appetizer::Populator.new t, foo: { bar: "baz" } do |p|
      p.nested :foo do |p|
        p.set :bar
      end
    end
  end

  def test_populate_target
    t2 = mock { expects(:bar=).with "baz" }
    t  = mock { expects(:foo).never }

    Appetizer::Populator.new t, foo: { bar: "baz" } do |p|
      p.populate :foo, t2 do |p|
        p.set :bar
      end
    end
  end

  def test_set
    t = mock { expects(:foo=).with("bar").twice }

    Appetizer::Populator.new t, foo: "bar" do |p|
      p.set :foo
      p.set "foo"
    end
  end

  def test_set_missing_source_value
    t = mock { expects(:foo=).never }

    Appetizer::Populator.new t, Hash.new do |p|
      p.set :foo
    end
  end

  def test_set_nil_source_value
    t = mock { expects(:foo=).never }

    Appetizer::Populator.new t, foo: nil do |p|
      p.set :foo
    end
  end

  def test_set_empty_source_value
    t = mock { expects(:foo=).never }

    Appetizer::Populator.new t, foo: "" do |p|
      p.set :foo
    end
  end

  def test_set_with_block
    t = mock { expects(:foo=).with "BAR" }

    Appetizer::Populator.new t, foo: "bar" do |p|
      p.set(:foo) { |v| p.target.foo = v.upcase }
    end
  end
end
