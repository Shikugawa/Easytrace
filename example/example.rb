require 'easytrace'

def test
    yield
end

test = Easytrace.new(:call, :return) do
    test do
        p "fucking"
    end
end