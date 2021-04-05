require 'json'

desserts = {
    'apple_pie' => {
        'recipe' => "Apple Pie",
        'rating' => 0,
        cooking_time: "1.5 Hours",
        recipe: {
            step_1: "Heat oven to 180 celcius",
            step_2: "Remove from packaging",
            step_3: "Put in oven",
            step_4: "Cook for 50min",
            step_5: "Let cool for 10min"
        }
    }
    'ice_cream' => {
        recipe: "Chocolate Ice-cream",
        rating: 0,
        cooking_time: "A good while",
        recipe: {
            step_1: "Find chocolate cow",
            step_2: "Milk chocolate milk",
            step_3: "Freeze chocolate milk and stir a-lot",
            step_4: "Eat chocolate ice-cream!"
        }
    }
}

File.open("dessert.json","w") do |f|
    f.write(JSON.pretty_generate(desserts))
end


def make_recipe(name, rating)
    name = {}
    rating = 
end

{
  "recipe_name": "Chocolate Ice Cream",
  "rating": 5,
  "cooking_time": "2 hours",
  "recipe": [
    "Step 1: Find brown cow",
    "Step 2: Milk the brown milk",
    "Step 3: Make the milk cold",
    "Step 4: Stir it alot",
    "Step 5: I think thats how you make ice-cream"
  ]
})