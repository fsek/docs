class Api::FruitsController < Api::BaseController
  load_permissions_and_authorize_resource

  def index
    @fruits = Fruit.all
    render json: @fruits,
    each_serializer: Api::FruitSerializer::Index
  end

  def show
    @fruit = Fruit.find(params[:id])
    render json: @fruit,
    serializer: Api::FruitSerializer::Show
  end
end
