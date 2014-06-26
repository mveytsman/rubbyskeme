require_relative "../lib/environment.rb"
include RubbySkeme
describe Environment do
  it "should add keys" do
    @env = Environment.new
    @env.add("foo",1)
    expect(@env.map).to eq({:foo => 1})
  end

  it "should retrieve keys" do
    @env = Environment.new({:foo => 1})
    expect(@env.find(:foo)).to eq(1)
  end

  it "should create children" do
    @parent = Environment.new
    @child = @parent.create_child
    expect(@child.parent).to eq(@parent)
  end

  it "should search parent's environment" do
    @parent = Environment.new({:foo => 1})
    @child = @parent.create_child
    expect(@child.find(:foo)).to eq(1)
  end
end
