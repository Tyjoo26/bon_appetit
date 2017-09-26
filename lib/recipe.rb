class Recipe
  attr_reader :name, :ingredients

  def initialize(name)
    @name = name
    @ingredients = {}
  end

  def ingredient_types
    @ingredients.keys
  end

  def add_ingredient(ingredient_name, amount)
    @ingredients[ingredient_name] = amount
  end

  def subtract_ingredient(ingredient_name, amount)
    @ingredients[ingredient_name] -= amount
  end

  def amount_required(ingredient_name)
    @ingredients[ingredient_name]
  end
end
