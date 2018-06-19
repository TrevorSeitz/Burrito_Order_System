class BurritoController < ApplicationController
  # this controller is/should only be accessed by admin
  before do
    # Check if User exists & is logged in
    if !current_user
      redirect "/"
    end
  end
  
  get "/burritos/new" do 
    # should have proper admin check here
    if current_user.username == "sam_the_owner"
    # go to new burrito form
    erb :"/burritos/new"
    else
      # got to burrito index
      redirect "/logout"
    end
  end

  get "/burritos/index" do
    @burritos = Burrito.all
    # go to list of burritos
    erb :"/burritos/index"
  end

  get "/burritos/:id" do
    # show single order
    @burrito = Burrito.find(params[:id].to_i)

    erb :'/burritos/show'
  end

  get "/burritos/:id/edit" do
    @burrito = Burrito.find_by_id(params[:id].to_i)
    
    # edit the burrito
    erb :"/burritos/edit"
  end

  post "/burritos/new" do
    # receive new burrito form and save burrito to burrito table
    @burrito = Burrito.new(params)  
    @burrito.save
    redirect "/burritos/new"
  end

  patch "/burritos/edit" do
    @burrito = Burrito.find_by_id(params[:id].to_i)
    @burrito.update({name: params[:name], description: params[:description], price: params[:price]})
    @burrito.save

    redirect "/burritos/index"    
  end

  delete '/burritos/:id' do
    # delete requested order and return to user index
    @burrito = Burrito.delete(params[:id])

    redirect "/burritos/index"
  end
end
