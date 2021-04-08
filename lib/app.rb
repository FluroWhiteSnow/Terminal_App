require 'yaml'
require 'tty-prompt'


class Recipe

    attr_accessor :entree, :main, :dessert, :all_recipes, :user_rating, :recipe_list, :input, :formated_recipe, :go_back, :temp, :file_read_variable

    def initialize()
        @prompt = TTY::Prompt.new
        @go_back
        @temp = temp
        @user_rating = user_rating
        @formated_recipe = formated_recipe
        @steps = {}
        @user_rating = user_rating
        @all_recipes = all_recipes
        @recipe_list = recipe_list
        @input = input
        @file_read_variable = file_read_variable
    end

    def run_all
        loop do
            system 'clear'
            menu
        end
    end

    def clean
        system 'clear'
    end

    def log_in
        puts "Username:"
        username = gets.chomp
        puts "Password:"
        password = gets.chomp

        if username == 'admin' && password == 'admin'
            run_all
        else 
            return log_in
        end
    end

    def menu()
        clean
        puts "Welcome to the recipe book!"
        welcome = @prompt.select("\nWhat would you like to do?") do |menu|
            menu.choice "Browse Recipes"
            menu.choice "Add Recipe"
            menu.choice "Edit Recipe" 
            menu.choice "Delete Recipe"
        end

        if welcome == 'Browse Recipes'
            browse_recipes
        elsif welcome == 'Add Recipe'
            make_recipe
        elsif welcome == 'Edit Recipe'
            edit_recipe
        elsif welcome == 'Delete Recipe'
            delete_recipe
        end
    end

    def edit_recipe
        food_menu("Where is the recipe you want to edit?",
        :edit_entree, :edit_main, :edit_dessert, :menu)
    end

    def edit_dessert
        load_data('dessert')
        @file_read_variable = 'dessert'
        pre_format_data('edit')
    end

    def delete_recipe
        food_menu("Where is the recipe you want to delete?",
        :del_entree, :del_main, :del_dessert, :menu)
    end

    def del_entree
        load_data('entree')
        @file_read_variable = 'entree'
        pre_format_data('delete')
    end

    def del_main
        load_data('main')
        @file_read_variable = 'main'
        pre_format_data('delete')
    end

    def del_dessert
        load_data('dessert')
        @file_read_variable = 'dessert'
        pre_format_data('delete')
    end

    def browse_recipes
        clean
        food_menu("What section would you like to browse?", 
            :run_entree, :run_main, :run_dessert, :menu)
    end

    def food_menu(greeting, entree='', main='', dessert='', back='')
        input = @prompt.select(greeting, 
            %w(Entree Mains Dessert Back))
        if input == 'Entree'
            public_send(entree)
        elsif input == 'Mains'
            public_send(main)
        elsif input == 'Dessert'
            public_send(dessert)
        elsif input == 'Back'
            public_send(back)
        end
    end

    def go_back(wanted_method='')
        puts "\n"
        input = @prompt.select('',%w(Back))
        if input == 'Back'
            menu
        end
    end

    def run_entree
        load_data('entree')
        @go_back = :run_entree
        pre_format_data('read')
    end

    def run_main
        load_data('main')
        @go_back = :run_main
        pre_format_data('read')
    end

    def run_dessert
        load_data('dessert')
        @go_back = :run_dessert
        pre_format_data('read')
    end
    
    def pre_format_data(read)
        @recipe_list = @all_recipes.keys
        @recipe_list.push("Back")

        if read == 'read' 
            option = @prompt.select("Select a recipe to browse!", @recipe_list)
            if option == 'Back'
                browse_recipes
            else
                @formated_recipe = @all_recipes.fetch_values(option).first
                format_recipe
            end
        end
        
        if read == 'delete'
            option = @prompt.select("Select a recipe to delete!", @recipe_list)

            if option == 'Back'
                browse_recipes
            else
                @all_recipes.delete(option)
                @recipe_list = @all_recipes.keys

                File.open("food_recipes/#{@file_read_variable}.yml", "w") { |file| file.write(@all_recipes.to_yaml) }
            end
        end

        if read == 'edit'
            option = @prompt.select("Select a recipe to edit!", @recipe_list)

            if option == 'Back'
                browse_recipes
            else
                @formated_recipe = all_recipes.fetch_values(option).first
                format_recipe('edit')
                
            end

        end
    end
    
    def format_recipe(temp='')
        clean
        if temp == ''
            puts "\nRecipe Name: #{@formated_recipe.fetch(:recipe_name)}" 
            puts "Rating: #{@formated_recipe.fetch(:rating)}/5"
            puts "Cooking time: #{@formated_recipe.fetch(:cooking_time)}"
            puts "\nSteps:"
            last_steps = @formated_recipe.fetch(:recipe)
            last_steps.each_pair{|key, value| puts "#{key} #{value}"}

        elsif temp == 'edit'
            input = @prompt.select("What would you like to edit?\n") do |menu|
                menu.choice name: "Recipe Name: #{@formated_recipe.fetch(:recipe_name)}",  value: 1
                menu.choice name: "Rating: #{@formated_recipe.fetch(:rating)}/5", value: 2
                menu.choice name: "Cooking time: #{@formated_recipe.fetch(:cooking_time)}",  value: 3
                menu.choice name: "Enter to expand steps:",  value: 4
            end
        end

        if input == 4
            last_steps = @formated_recipe.fetch(:recipe)

            input = @prompt.select("Which step would you like to edit?\n") do |menu|
                last_steps.each_pair do |key, value| 
                    menu.choice "#{key} #{value}", key
                end
            end
            
            edit_value = @prompt.ask(input, value:last_steps[input])
            @formated_recipe[input] = edit_value
        end

        go_back(@go_back)
    end

    def load_data(food_group)

        temp_hash = {}

        if food_group == 'entree'
            YAML.load_stream(File.read('food_recipes/entree.yml')){|doc| temp_hash.merge!(doc)}
        elsif food_group == 'main'
            YAML.load_stream(File.read('food_recipes/main.yml')){|doc| temp_hash.merge!(doc)}
        elsif food_group == 'dessert'
            YAML.load_stream(File.read('food_recipes/dessert.yml')){|doc| temp_hash.merge!(doc)}
        end
        
        @all_recipes = temp_hash
    end

    def make_recipe()
        clean
        catergory = @prompt.select("What catergory is your recipe?",
        %w(Entree Main Dessert)).downcase

        puts "What is the recipes name?"
        recipe_name = gets.chomp
        hash_name = recipe_namelast_steps

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

        File.open("food_recipes/#{catergory}.yml", "a") { |file| file.write(hash_name.to_yaml) }        
    end

    def get_steps
        clean
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
        @user_rating = gets.chomp.to_f
        if user_rating < 0 || user_rating > 5
            puts "Invalid score"
            puts "Enter a score between 0 and 5"
            return rating
        end
    end
end

ananda = Recipe.new 
ananda.log_in
# ananda.make_recipe