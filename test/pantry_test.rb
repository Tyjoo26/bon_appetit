require './lib/pantry'
require './lib/recipe'
require 'minitest/autorun'
require 'minitest/pride'

class PantryTest < Minitest::Test
  def test_it_exists?
    pantry = Pantry.new

    assert_instance_of Pantry, pantry
  end

  def test_stock_has_empty_hash
    pantry = Pantry.new
    expected = {}

    assert_equal expected, pantry.stock
  end

  def test_stock_check_returns_zero
    pantry = Pantry.new

    assert_equal 0, pantry.stock_check("Cheese")
  end

  def test_after_restock_stock_check_returns_number
    pantry = Pantry.new
    pantry.restock("Cheese", 10)

    assert_equal 10, pantry.stock_check("Cheese")
  end

  def test_after_multiple_restocks_stock_check_returns_new_number
    pantry = Pantry.new
    pantry.restock("Cheese", 10)
    pantry.restock("Cheese", 20)

    assert_equal 30, pantry.stock_check("Cheese")
  end

  def test_check_instance_of_recipe_and_ingredients

    r = Recipe.new("Cheese Pizza")
    assert_instance_of Recipe, r

    expected = {}
    assert_equal expected, r.ingredients
  end

  def test_check_if_add_ingredients_works
    r = Recipe.new("Cheese Pizza")
    r.ingredients
    r.add_ingredient("Cheese", 20)
    r.add_ingredient("Flour", 20)

    expected = {"Cheese" => 20, "Flour" => 20}
    assert_equal expected, r.ingredients
  end

  def test_add_to_shopping_list_adds_to_shopping_list
    pantry = Pantry.new
    r = Recipe.new("Cheese Pizza")
    r.ingredients
    r.add_ingredient("Cheese", 20)
    r.add_ingredient("Flour", 20)

    pantry.add_to_shopping_list(r)
    expected = {"Cheese" => 20, "Flour" => 20}

    assert_equal expected, pantry.shopping_list
  end

  def test_update_shopping_list_after_multiple_add_to_shopping_list

    pantry = Pantry.new
    r = Recipe.new("Cheese Pizza")
    r.ingredients
    r.add_ingredient("Cheese", 20)
    r.add_ingredient("Flour", 20)
    pantry.add_to_shopping_list(r)

    r = Recipe.new("Spaghetti")
    r.add_ingredient("Noodles", 10)
    r.add_ingredient("Sauce", 10)
    r.add_ingredient("Cheese", 5)
    pantry.add_to_shopping_list(r)

    expected = {"Cheese" => 25, "Flour" => 20, "Noodles" => 10, "Sauce" => 10}

    assert_equal expected, pantry.shopping_list
  end

  def test_check_shopping_list_after_subtract_method
    pantry = Pantry.new
    r = Recipe.new("Cheese Pizza")
    r.ingredients
    r.add_ingredient("Cheese", 20)
    r.subtract_ingredient("Cheese", 10)
    r.add_ingredient("Flour", 20)
    pantry.add_to_shopping_list(r)

    r = Recipe.new("Spaghetti")
    r.add_ingredient("Noodles", 10)
    r.subtract_ingredient("Noodles", 5)
    r.add_ingredient("Sauce", 10)
    r.add_ingredient("Cheese", 5)
    pantry.add_to_shopping_list(r)

    expected = {"Cheese" => 15, "Flour" => 20, "Noodles" => 5, "Sauce" => 10}

    assert_equal expected, pantry.shopping_list
  end

  def test_print_shopping_list
    pantry = Pantry.new
    r = Recipe.new("Cheese Pizza")
    r.ingredients
    r.add_ingredient("Cheese", 20)
    r.add_ingredient("Flour", 20)
    pantry.add_to_shopping_list(r)

    r = Recipe.new("Spaghetti")
    r.add_ingredient("Noodles", 10)
    r.add_ingredient("Sauce", 10)
    r.add_ingredient("Cheese", 5)
    pantry.add_to_shopping_list(r)

    expected = "* Cheese: 25\n* Flour: 20\n* Noodles: 10\n* Sauce: 10"

    assert_equal expected, pantry.print_shopping_list
  end

  def test_what_can_i_make
    pantry = Pantry.new
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)

    pantry.restock("Cheese", 10)
    pantry.restock("Flour", 20)
    pantry.restock("Brine", 40)
    pantry.restock("Cucumbers", 40)
    pantry.restock("Raw nuts", 20)
    pantry.restock("Salt", 20)

    expected = ["Pickles", "Peanuts"]

    assert_equal expected, pantry.what_can_i_make
  end

  def test_how_many_can_i_make
    pantry = Pantry.new
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    r4 = Recipe.new("Brine Shot")
    r4.add_ingredient("Brine", 10)

    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)
    pantry.add_to_cookbook(r4)

    pantry.restock("Cheese", 10)
    pantry.restock("Flour", 20)
    pantry.restock("Brine", 40)
    pantry.restock("Pickles", 40)
    pantry.restock("Raw nuts", 20)
    pantry.restock("Salt", 20)

    expected = {"Brine Shot" => 4, "Peanuts" => 2}

    assert_equal expected, pantry.how_many_can_i_make
  end

  def test_convert_units
    r = Recipe.new("Spicy Cheese Pizza")
    r.add_ingredient("Cayenne Pepper", 0.025)
    r.add_ingredient("Cheese", 75)
    r.add_ingredient("Flour", 500)

    pantry = Pantry.new

    expected = {"Cayenne Pepper" => {quantity: 25, units: "Milli-Units"}, "Cheese" => {quantity: 75, units: "Universal Units"}, "Flour" => {quantity: 5, units: "Centi-Units"}}

    assert_equal expected, pantry.convert_units(r)
  end


end
