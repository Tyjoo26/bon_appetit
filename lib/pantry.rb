require 'pry'

class Pantry

  attr_reader :stock, :shopping_list

  def initialize
    @stock = Hash.new(0)
    @shopping_list = {}
    @cookbook = []
  end

  def stock_check(ingredient)
    @stock[ingredient]
  end

  def restock(ingredient, quantity)
    @stock[ingredient] += quantity
  end

  def add_to_shopping_list(recipe)
    recipe.ingredients.each_pair do |key, value|
      if @shopping_list.has_key?(key)
        @shopping_list[key] += value
      else
        @shopping_list[key] = value
      end
    end
  end


  def print_shopping_list
    output = ""
      @shopping_list.each_pair do |key, value|
        output << "* #{key}: #{value}\n"
      end
    output.rstrip
  end

  def add_to_cookbook(recipe)
    @cookbook << recipe
  end

  def iterate_through_cookbook
    @cookbook.find_all do |recipe|
      check_cookbook(recipe)
    end
  end

  def check_cookbook(recipe)
    recipe.ingredients.each_pair do |key, value|
      if stock_check(key) < value
        break
      end
    end
  end

  def what_can_i_make
    iterate_through_cookbook.map do |recipe|
      recipe.name
    end
  end

  def how_many_can_i_make
    recipes_hash = {}
    iterate_through_cookbook.each do |recipe|
      results = []
      calculate_how_many(recipes_hash, results, recipe)
    end
    recipes_hash
  end

  def calculate_how_many(recipes_hash, results, recipe)
    recipe.ingredients.each_pair do |key, value|
      results << (stock_check(key) / value)
    end
      recipes_hash[recipe.name] = results.max.to_i
  end

  def convert_units(recipe)
    recipe.ingredients.each_pair do |key, value|
      recipe.ingredients[key] = conversion(value)
    end
    recipe.ingredients
  end

  def conversion(value)
    if value < 1
      {quantity: (value * 1000).to_i, units: "Milli-Units"}
    elsif value > 100
      {quantity: (value / 100), units: "Centi-Units"}
    else
      {quantity: value, units: "Universal Units"}
    end
  end


end
