require 'yaml'
require 'tty-prompt'


class Recipe
    attr_accessor :entree, :main, :dessert, :user_rating, :dessert_list, :input, :formated_recipe

    def initialize()
        @prompt = TTY::Prompt.new
        @user_rating = user_rating
        @formated_recipe = formated_recipe
        @steps = {}
        @user_rating = user_rating
        @dessert = dessert
        @dessert_list = dessert_list
        @input = input
    end

    def menu()
        welcome = @prompt.select("\nWhat would you like to do?") do |menu|
            menu.choice "Browse Recipes"
            menu.choice "Add Recipe"
            menu.choice "Edit Recipe" 
            menu.choice "Delete Recipe"
        end

        if welcome == 'Browse Recipes'
            browse_recipes
        elsif welcome == 'Add Recipe'
            add_recipe
        elsif welcome == 'Edit Recipe'
            edit_recipe
        elsif welcome == 'Delete Recipe'
            delete_recipe
        end
    end

    def browse_recipes
        puts "\nWelcome to the recipe book!"
        food_menu("What section would you like to browse?", run_entree, run_main, run_dessert)
    end

    def food_menu(greeting, entree='', main='', dessert='')
         input = @prompt.select(greeting, 
            %w(Entree Mains Dessert))
        if input == 'Entree'
            entree
        elsif input == 'Mains'
            main
        elsif input == 'Dessert'
            dessert
        end
    end

    def go_back(wanted_method='')
        puts "\n"
        input = @prompt.select('',%w(Back))
        if input == 'Back'
            public_send(wanted_method)
        end
    end

    def run_entree

    end
    def run_main

    end

    def run_dessert
        load_data
        @dessert_list = @dessert.keys
        option = @prompt.select("Select a recipe to browse!", @dessert_list)
        @formated_recipe = @dessert.fetch_values(option).first
        format_recipe
    end

    def format_recipe
        puts "\nRecipe Name: #{@formated_recipe.fetch(:recipe_name)}" 
        puts "Rating: #{@formated_recipe.fetch(:rating)}/5"
        puts "Cooking time: #{@formated_recipe.fetch(:cooking_time)}"
        puts "\nSteps:"
        last_steps = @formated_recipe.fetch(:recipe)
        last_steps.each_pair{|key, value| puts "#{key} #{value}"}
        
        go_back(:run_dessert)
     

    end

    def load_data()
        temp_hash = {}
        YAML.load_stream(File.read('food_recipes/dessert.yml')){|doc| temp_hash.merge!(doc)}
        @dessert = temp_hash
    end

    def make_recipe()
        food_menu("What catergory is your recipe?")
        catergory = @input

        puts "What is the recipes name?"
        recipe_name = gets.chomp
        hash_name = recipe_name

        rating
        puts"How long does this take to cook?"
        cooking_time = gets.chomp
        get_steps

        hash_name = {
            recipe_name => {
            recipe_name: recipe_name,
            rating: @user_rating,
            cooking_time: cooking_time,
            recipe: @steps}
        }

        File.open("food_recipes/dessert.yml", "a") { |file| file.write(hash_name.to_yaml) }        
    end

    def get_steps
        puts "Please enter the steps on how to make this recipe!"
        puts "Type 'done' when you are finished!"
        puts "Step 1:"
        
        input = gets.chomp
        new_input = {"Step 1: " => input}
        @steps.merge!(new_input)

        step = 1

        while input
            puts "Step #{step + 1}:\n"
            input = gets.chomp

            if input == 'done'
                return
            end

            step += 1
            new_input = {"Step #{step}: " => input}
            @steps.merge!(new_input)
        end
    end

    def rating
        puts"How would you rate this recipe out of 5?"
        @user_rating = gets.chomp.to_i
        if user_rating < 0 || user_rating > 5
            puts "Invalid score"
            puts "Enter a score between 0 and 5"
            return rating
        end
    end
end

ananda = Recipe.new 
ananda.menu
# ananda.make_recipe