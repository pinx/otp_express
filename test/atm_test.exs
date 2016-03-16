defmodule AtmTest do
  use ExUnit.Case

  test "start - stop" do
    Atm.start
    Atm.stop
  end
end
