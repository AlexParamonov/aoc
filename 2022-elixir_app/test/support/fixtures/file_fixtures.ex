defmodule ElixirApp.FileFixtures do
  def content(path) do
    File.read!(Path.join(__DIR__, "/files/#{path}"))
  end
end
