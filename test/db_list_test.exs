defmodule DbListTest do
  use ExUnit.Case

  require Logger

  test "empty" do
    assert DbList.empty == []
  end

  test "insert" do
    account = %Account{}
    db_list = DbList.empty
    assert DbList.insert(account, db_list) == [account]
  end

  test "to_list" do
    list = list1
    assert DbList.db_to_list(list) == list
  end

  test "size" do
    list = list1
    assert DbList.db_size(list) == 1
  end

  test "lookup" do
    list = list3
    account = DbList.lookup(2, list)
    assert (DbList.lookup(2, list)).no == 2
  end

  test "lookup_all" do
    list = list3
    assert Enum.count(DbList.lookup_all(:name, "a", list)) == 2
  end

  test "update" do
    list = list3
    old_size = Enum.count(list)
    list = DbList.update(%Account{no: 1, name: "c"}, list)
    new_account = DbList.lookup(1, list)
    assert new_account == %Account{no: 1, name: "c"}
    assert Enum.count(list) == old_size
  end

  defp test_account do
    %Account{no: 1, name: "a"}
  end

  defp list1 do
    db_list = DbList.empty
    DbList.insert(test_account, db_list)
  end

  defp list3 do
    db_list = DbList.empty
    db_list = DbList.insert(%Account{no: 1, name: "a"}, db_list)
    db_list = DbList.insert(%Account{no: 2, name: "a"}, db_list)
    db_list = DbList.insert(%Account{no: 3, name: "b"}, db_list)
  end

end

