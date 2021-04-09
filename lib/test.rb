

YAML.load_stream(File.read('food_recipes/entree.yml')){|doc| temp_hash.merge!(doc)}


 def yaml_load_default(food_type)
        if food_type == 'all'
            food_type = ['entree','main','dessert']
        else
            food_type = [food_type]
        end
        
    end

    , "Apple Pie", "DougNut", "Creme Brulee", "Chocolate Ice-Cream", "Steak", "Salad", "Savoy", "Spring Roll", "Dip", "Pineapple"