class DogsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_dog, only: [:show, :edit, :update, :destroy]
  access all: [:show, :index, :home], user: {except: [:test]}, site_admin: :all

  # GET /dogs
  # GET /dogs.json
  def index
    @dogs = Dog.search(params[:search]).filters(params[:breed_id], params[:city_id], params[:age_id]).order(sort_column + " " + sort_direction).page(params[:page]).per(2)
  end

  def home
  end

  def favorites
  end

  def my_list
    if params[:sort_by] == "breed" 
      @dogs = Dog.where(user_id: current_user.id).order("breed_id ASC")
    elsif params[:sort_by] == "age" 
      @dogs = Dog.where(user_id: current_user.id).order("age_id ASC")
    elsif params[:sort_by] == "city" 
      @dogs = Dog.where(user_id: current_user.id).order("city_id ASC") 
    else
      @dogs = Dog.where(user_id: current_user.id).order("created_at DESC")
    end
  end

  def test
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
    @favorite_exists = Favorite.where(dog: @dog, user: current_user) == [] ? false : true
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)
    @dog.user_id = current_user.id

    respond_to do |format|
      if @dog.save
        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def dog_params
      params.require(:dog).permit(:name, :breed_id, :city_id, :age_id, :description, :user_id, :sort, :direction)
    end

    def sort_column
      Dog.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end
