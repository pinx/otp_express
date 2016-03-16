defmodule Atm do
  require Logger

  @behaviour :gen_fsm
  # http://erlang.org/doc/man/gen_fsm.html

  defmodule State do
    defstruct [
      name: nil,
      account_no: nil,
      input: [],
      pin: nil
    ]
  end

  def start() do
    :gen_fsm.start({:local, __MODULE__}, __MODULE__, [], [])
  end

  def start_link() do
    :gen_fsm.start_link({:local, __MODULE__}, __MODULE__, [], [])
  end

  def stop() do
    :gen_fsm.send_event(__MODULE__, :stop)
  end

  # to get rid of warnings
  def code_change(_,_,_,_) do
  end
  def handle_event(_event, _state_name, _state) do
  end
  def handle_sync_event(_event, _from, _state_name, _state) do
  end
  def handle_info(_info, _state_name, _state) do
  end

  # callbacks

  def init(args) do
    # page 20 of training manual, fsm section
    {:ok, :idle, nil}
  end

  def terminate(reason, state_name, state) do
    :ok
  end

  def idle(:stop, state) do
    {:stop, :normal, nil}
  end
  
  def idle(:card_inserted, state) do
    {:card_inserted, :normal, state}
  end

  def card_inserted(state) do
  end

end

