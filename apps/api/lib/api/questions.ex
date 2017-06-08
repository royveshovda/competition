defmodule Api.Questions do
  def q1() do
    Application.get_env(:api, :questions)[:q1]
  end

  def a1() do
    Application.get_env(:api, :questions)[:a1]
  end

  def q2() do
    Application.get_env(:api, :questions)[:q2]
  end

  def a2() do
    Application.get_env(:api, :questions)[:a2]
  end

  def q3() do
    Application.get_env(:api, :questions)[:q3]
  end

  def a3() do
    Application.get_env(:api, :questions)[:a3]
  end
end
