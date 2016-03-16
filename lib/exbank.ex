defmodule Exbank do
  use Application

  def start(_type, _args) do
    ExbankSup.start()
  end

end
