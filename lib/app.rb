require 'yaml'
require 'tty-prompt'


class Recipe

    attr_accessor :entree, :main, :dessert, :all_recipes, :user_rating,
    :recipe_list, :input, :formated_recipe, :go_back, :temp, :file_read_variable, :users,
    :username, :password, :submited_recipe, :user_recipes, :user_edit_recipes, :staged_names, :staged_recipe_option, 
    :food_catergories, :default_recipes, :prompt

    def initialize()
        @prompt = TTY::Prompt.new
        @username = username
        @password = password
        @go_back
        @food_catergories = ['entree','main','dessert']
        @temp = temp
        @user_rating = user_rating
        @formated_recipe = formated_recipe
        @steps = {}
        @user_rating = user_rating
        @all_recipes = all_recipes
        @recipe_list = recipe_list
        @input = input
        @file_read_variable = file_read_variable
        @user = {}
        @submited_recipe = submited_recipe
        @staged_names = staged_names
        @user_recipes = user_recipes
        @user_edit_recipes = user_edit_recipes
        @staged_recipe_option = staged_recipe_option
        @default_recipes = ["Apple Pie", "DougNut", "Creme Brulee", "Chocolate Ice-Cream", "Steak", "Salad", "Savoy", "Spring Roll", "Dip", "Pineapple"]
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

    def log_in_menu
        menu = @prompt.select("\nWhat would you like to do?") do |menu|
            menu.choice "Log in"
            menu.choice "Create account"
        end
        if menu == "Log in"
            log_in
        else 
            create_account
        end
    end

    def create_account
        load_accounts
        get_username

        if @all_accounts.has_key?(@username)
            puts "That username has already been taken! \nPlease try another!"
            get_username
        end

        get_password
        write_new_user
        write_user_recipes
        run_all
    end

    def get_username
        print "Please enter you username: "
        @username = gets.chomp.downcase
    end

    def get_password
        print "Please enter your password: "
        @password = gets.chomp.downcase
    end

    def load_accounts
        @all_accounts = {}
        YAML.load_stream(File.read('users/users.yml')){|doc| @all_accounts.merge!(doc)}
    end

    def write_new_user
        @user = {@username => @password}
        File.open("users/users.yml", "a") { |file| file.write(@user.to_yaml) }
    end

    def write_user_recipes
        file_open_user_write('all')
        populate_user_recipes
    end

    def file_open_user_write(food_type)
        if food_type == 'all'
            food_type = @food_catergories
        else
            food_type = [food_type]
        end
        food_type.each{|course|File.open("food_recipes/user_recipes/#{@username}_#{course}.yml", "w")}
    end

    def populate_user_recipes
        temp_hash = {}

        @food_catergories.each {|food_catergorie|
            YAML.load_stream(File.read("food_recipes/#{food_catergorie}.yml")){|doc| temp_hash.merge!(doc)}
            File.open("food_recipes/user_recipes/#{@username}_#{food_catergorie}.yml", "w"){ |file| file.write(temp_hash.to_yaml) }
            temp_hash.clear
        }
    end

    def log_in
        load_accounts
        get_username
        get_password

        if @all_accounts.has_key?(@username)
            password = @all_accounts.fetch(@username)
            if password== @password
                unless @username == 'admin'
                    update_recipes
                end
                run_all
            else
                puts "You may have entered the wrong password!"
                puts "Please log in again!"
                gets
                clean
                log_in
            end
        else
            puts "User does not exist"
            option = @prompt.select("\nWhat would you like to do?") do |menu|
                menu.choice "Login"
                menu.choice "Create account"
            end
            if option == "Login"
                log_in
            else
                create_account
            end
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
            unless @username == 'admin'
                menu.choice "Submit Recipe to global book"
            else
                menu.choice "Review recipes for submission"
            end
        end

        if welcome == 'Browse Recipes'
            browse_recipes
        elsif welcome == 'Add Recipe'
            make_recipe
        elsif welcome == 'Edit Recipe'
            edit_recipe
        elsif welcome == 'Delete Recipe'
            delete_recipe
        elsif welcome == "Submit Recipe to global book"
            stage_recipe
        elsif welcome == "Review recipes for submission"
            review_submission
        end
    end

    def edit_recipe
        food_menu("Where is the recipe you want to edit?",
        :edit_entree, :edit_main, :edit_dessert, :menu)
    end
    
    def edit_entree
        load_data('entree')
        @file_read_variable = 'entree'
        pre_format_data('edit')
    end

    def edit_main
        load_data('main')
        @file_read_variable = 'main'
        pre_format_data('edit')
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
        
        unless read == 'admin_review'
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

            if read == 'stage'
                load_data('all')
                @all_recipes.delete_if {|name| @default_recipes.include?(name)}
                
                options =  @all_recipes.keys
                options.push('Back')
                option = prompt.select("Select a recipe to edit!", options)
                
                if option == 'Back'
                    menu
                else
                    recipe_values = @all_recipes.fetch(option)
                    staged_recipe = {option => recipe_values}
                    File.open("food_recipes/staged_recipes/staging.yml", "a") { |file| file.write(staged_recipe.to_yaml) } 
                end
            end
            
            if read == 'delete'
                if @username == 'admin'
                    option = @prompt.select("Select a recipe to delete!", @recipe_list)

                    if option == 'Back'
                        menu
                    else
                        @all_recipes.delete(option)
                        @recipe_list = @all_recipes.keys
                    end
                    File.open("food_recipes/user_recipes/#{@username}_#{@file_read_variable}.yml", "w") { |file| file.write(@all_recipes.to_yaml) }
                
                else
                    load_data(@file_read_variable)
                    @all_recipes.delete_if {|name| @default_recipes.include?(name)}
                
                    options =  @all_recipes.keys
                    options.push('Back')
                    option = prompt.select("Select a recipe to delete!", options)

                    if option == 'Back'
                        menu
                    else
                        @all_recipes.delete(option)
                        @recipe_list = @all_recipes.keys
                        File.open("food_recipes/#{@file_read_variable}.yml", "w") { |file| file.write(@all_recipes.to_yaml) }
                    end
                end
                
            end

            if read == 'edit'
                unless @username == 'admin'
                    load_data(@file_read_variable)

                    @all_recipes.delete_if {|name| @default_recipes.include?(name)}
                    options =  @all_recipes.keys
                    options.push('Back')

                    option = prompt.select("Select a recipe to edit!", options)
                    
                    if option == 'Back'
                        menu
                    else
                        @formated_recipe = all_recipes.fetch_values(option).first
                        format_recipe('edit')
                    end

                else
                    option = @prompt.select("Select a recipe to edit!", @recipe_list)

                    if option == 'Back'
                        menu
                    else
                        @formated_recipe = all_recipes.fetch_values(option).first
                        format_recipe('edit')
                    end
                end
            end   

        else read == 'admin_review'
            @staged_recipe_option = @prompt.select("Review recipe:", @staged_names)
            if @staged_recipe_option == 'back'
                menu
            else
                @formated_recipe = @submited_recipe.fetch_values(@staged_recipe_option).first
                format_recipe('stage')
            end
        end
    end

    def format_recipe(temp='')
        clean

        def write_to_user_file
            File.open("food_recipes/user_recipes/#{@username}_#{@file_read_variable}.yml", "w") { |file| file.write(@all_recipes.to_yaml) }
        end

        def write_to_default
            File.open("food_recipes/#{@file_read_variable}.yml", "w") { |file| file.write(@all_recipes.to_yaml) }
        end

        if temp == '' || temp == 'stage'
            puts "\nRecipe Name: #{@formated_recipe.fetch(:recipe_name)}" 
            puts "Rating: #{@formated_recipe.fetch(:rating)}/5"
            puts "Cooking time: #{@formated_recipe.fetch(:cooking_time)}"
            puts "\nSteps:"
            last_steps = @formated_recipe.fetch(:recipe)
            last_steps.each_pair{|key, value| puts "#{key} #{value}"}

            def file_path(food_type)
                temp_hash = {@staged_recipe_option => @submited_recipe.fetch(@staged_recipe_option)}
                File.open("food_recipes/#{food_type}.yml", 'a'){|doc| temp_hash.merge!.to_yaml(doc)} 
                new_deafult = @formated_recipe.fetch(:recipe_name)
            
                @default_recipes.push(new_deafult)
                staging_delete
            end

            if temp == 'stage'
                option = @prompt.select("What would you like to do to this recipe?",
                %w(Add Delete Home))
                if option == 'Add'
                    option = @prompt.select("What type of recipe is this?",
                    %w(Entree Main Dessert))
                    if option == 'Entree'
                        file_path('entree')
                    elsif option == 'Main'
                        file_path('main')
                    else 
                        file_path('dessert')
                    end
                elsif option == 'Delete'
                    staging_delete
                else
                    menu
                end
            end

        elsif temp == 'edit'
            input = @prompt.select("What would you like to edit?\n") do |menu|
                menu.choice name: "Recipe Name: #{@formated_recipe.fetch(:recipe_name)}",  value: 1
                menu.choice name: "Rating: #{@formated_recipe.fetch(:rating)}/5", value: 2
                menu.choice name: "Cooking time: #{@formated_recipe.fetch(:cooking_time)}",  value: 3
                menu.choice name: "Enter to expand steps:",  value: 4
            end
        end

        if input == 1
            edit_name = @formated_recipe.fetch(:recipe_name)
            finish_edit = @prompt.ask("Recipe Name: ", value:edit_name)
            @formated_recipe[:recipe_name] = finish_edit
            @recipe_list = @all_recipes.keys
        
            if @all_recipes.has_key?(edit_name)
                @all_recipes[finish_edit] = @all_recipes.delete edit_name
            end
            
            unless @username == 'admin'
                load_stage_data('edit')
                write_to_user_file
            else 
                write_to_default
            end
        
        elsif input == 3
            edit_time = @formated_recipe.fetch(:cooking_time)
            finish_edit = @prompt.ask("Cooking time: ", value:edit_time)

            @formated_recipe[:cooking_time] = finish_edit
            @recipe_list = @all_recipes.keys
            
            unless @username == 'admin'
                load_stage_data('edit')
                write_to_user_file
            else 
                write_to_default
            end

        elsif input == 4
            last_steps = @formated_recipe.fetch(:recipe)

            input = @prompt.select("Which step would you like to edit?\n") do |menu|
                last_steps.each_pair do |key, value| 
                    menu.choice "#{key} #{value}", key
                end
            end
    
            edit_value = @prompt.ask(input, value:last_steps[input])
            @formated_recipe[:recipe][input] = edit_value
            @recipe_list = @all_recipes.keys

            unless @username == 'admin'
                load_stage_data('edit')
                write_to_user_file
            else 
                write_to_default
            end 
        end

        go_back(@go_back)
    end
    
    def staging_delete
        @submited_recipe.delete(@staged_recipe_option)
        File.open("food_recipes/staged_recipes/staging.yml", "w") { |file| file.write(@submited_recipe.to_yaml) }
    end

    def load_data(food_group='')
        
        temp_hash = {}
        
        if food_group == 'entree'
            YAML.load_stream(File.read('food_recipes/entree.yml')){|doc| temp_hash.merge!(doc)}
            if @username != 'admin'
                YAML.load_stream(File.read("food_recipes/user_recipes/#{@username}_entree.yml")){|doc| temp_hash.merge!(doc)}    
            end

        elsif food_group == 'main'
            YAML.load_stream(File.read('food_recipes/main.yml')){|doc| temp_hash.merge!(doc)}
            if @username != 'admin'
                YAML.load_stream(File.read("food_recipes/user_recipes/#{@username}_main.yml")){|doc| temp_hash.merge!(doc)}
            end

        elsif food_group == 'dessert'
            YAML.load_stream(File.read('food_recipes/dessert.yml')){|doc| temp_hash.merge!(doc)}

            if @username != 'admin'
                YAML.load_stream(File.read("food_recipes/user_recipes/#{@username}_dessert.yml")){|doc| temp_hash.merge!(doc)}
            end

        elsif food_group == 'all'
            YAML.load_stream(File.read("food_recipes/user_recipes/#{@username}_entree.yml")){|doc| temp_hash.merge!(doc)}
            YAML.load_stream(File.read("food_recipes/user_recipes/#{@username}_main.yml")){|doc| temp_hash.merge!(doc)}
            YAML.load_stream(File.read("food_recipes/user_recipes/#{@username}_dessert.yml")){|doc| temp_hash.merge!(doc)}
        end
        
        @all_recipes = temp_hash
    end

    def stage_recipe
        load_stage_data
        pre_format_data('stage')
    end

    def update_recipes
        updated_recipe_list = {}

        YAML.load_stream(File.read("food_recipes/entree.yml")){|doc| updated_recipe_list.merge!(doc)}
        YAML.load_stream(File.read("food_recipes/user_recipes/#{@username}_entree.yml")){|doc| updated_recipe_list.merge!(doc)}
        
        updated_recipe_list.clear
        YAML.load_stream(File.read("food_recipes/main.yml")){|doc| updated_recipe_list.merge!(doc)}
        YAML.load_stream(File.read("food_recipes/user_recipes/#{@username}_main.yml")){|doc| updated_recipe_list.merge!(doc)}
        
        updated_recipe_list.clear
        YAML.load_stream(File.read("food_recipes/dessert.yml")){|doc| updated_recipe_list.merge!(doc)}
        YAML.load_stream(File.read("food_recipes/user_recipes/#{@username}_dessert.yml")){|doc| updated_recipe_list.merge!(doc)}
    end

    def load_stage_data(edit='')
        temp_hash = {}

        if edit == "edit"
            YAML.load_stream(File.read("food_recipes/user_recipes/#{@username}_entree.yml")){|doc| temp_hash.merge!(doc)}
            YAML.load_stream(File.read("food_recipes/user_recipes/#{@username}_main.yml")){|doc| temp_hash.merge!(doc)}
            YAML.load_stream(File.read("food_recipes/user_recipes/#{@username}_dessert.yml")){|doc| temp_hash.merge!(doc)}
            @user_edit_recipes = temp_hash
        else
            YAML.load_stream(File.read("food_recipes/user_recipes/#{@username}_entree.yml")){|doc| temp_hash.merge!(doc)}
            YAML.load_stream(File.read("food_recipes/user_recipes/#{@username}_main.yml")){|doc| temp_hash.merge!(doc)}
            YAML.load_stream(File.read("food_recipes/user_recipes/#{@username}_dessert.yml")){|doc| temp_hash.merge!(doc)}
            @all_recipes = temp_hash
        end
    end
    
    def review_submission
        @submited_recipe = {}
        YAML.load_stream(File.read("food_recipes/staged_recipes/staging.yml")) {|doc| @submited_recipe.merge!(doc)}
        @staged_names = @submited_recipe.keys

        pre_format_data('admin_review')
    end

    def make_recipe()
        clean
        catergory = @prompt.select("What catergory is your recipe?",
        %w(Entree Main Dessert)).downcase

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

        if @username == 'admin'
            File.open("food_recipes/#{catergory}.yml", "a") { |file| file.write(hash_name.to_yaml) } 
        else
            File.open("food_recipes/user_recipes/#{@username}_#{catergory}.yml", "a") { |file| file.write(hash_name.to_yaml) } 
        end
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
ananda.log_in_menu
# ananda.make_recipe