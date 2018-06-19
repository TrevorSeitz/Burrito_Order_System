class OrderController < ApplicationController
  
  before do
    # Check if User exists & is logged in
    if !current_user
      redirect "/"
    end
    # Create @user
    @user = User.find_by_id(session[:user_id])
    # Create @store
    @store = Store.find_by_id(@user.store_id)
  end

  get "/orders/new" do
    @burrito = Burrito.all
    # go to order form
    erb :"/orders/new"
  end
  
  get "/orders/preview" do
    # collect burritos for order
    @order = Order.find_by_id(@user.order_ids)
    @order_items = @order.burritos

    # preview order
    erb :"/orders/preview"
  end

  get "/orders/edit" do
    @order = Order.find_by_id(@user.order_ids)
    @burrito = Burrito.all
    @order_items = @order.burritos

    # edit the order
    erb :"/orders/edit"
  end

  get '/orders/history' do
    # collect the user's orders
    @orders = Order.all.find_all{|order| order["user_id"] == current_user.id }

    # show user's order history
    erb :"/orders/history"
  end

  get '/errors/orders/blank_order' do
    @burritos = Burrito.all
    erb :'/errors/orders/blank_order'
  end

  get '/orders/:id' do
    # show single order
    @order = Order.find(params[:id])
    @order_items = OrderBurrito.all.where(order_id:  params[:id].to_i)

    erb :'/orders/show'
  end

  post "/orders/new" do
    # create new order and assign store and user to it
    @order = Order.new(store_id: @user.store_id, user_id: @user.id)
    @order.save
    # assign new order id to user
    @user.order_ids = @order.id
    @user.save
    # ensure there are no empty orders
    @item_count = 0
    # save order to order_burrito table  
    params[:burritos].each do |item|
      binding.pry
      if item[:quantity].to_i > 0
        # increase item count if quantity is > 0
        @item_count += 1
        # bring in current burrito element
        @burrito = Burrito.find_by_id(item[:id].to_i)
        @burrito.quantity = item[:quantity].to_i
        @burrito.save
        # save each ordered burrito to order_burrito
        OrderBurrito.create(order_id: @order.id, user_id: @user.id, burrito_id: @burrito.id, quantity: @burrito.quantity, item_price: @burrito.price)
      end
      # if quantity is not > 0 go to next item
    end
    if @item_count < 1
      # if item count 0 - go to error for blank order
      redirect '/errors/orders/blank_order'
    end
    # otherwise go to preview page
    redirect "/orders/preview"
  end

  patch "/orders/edit" do
    # edit order
    item_count = 0
    binding.pry
    @order = Order.find_by_id(@user.order_ids)
    # gather all items from order_burrito for this order
    @order_items = @order.burritos
    #  sort through the edited order 
    params[:burritos].each do |burrito|
      @burrito = Burrito.find_by_id(burrito[:id].to_i)
      if burrito[:quantity].to_i >0
        # checking for 0 item order
        item_count += 1
      end
      # check to see it item is already in the order
      binding.pry
      #@current_item = @order_items.where(burrito_id: burrito[:id].to_i)
      # if @order_item == [] 
      #   # if it is not and the quantity > 0 - add to order
      #   if burrito[:quantity].to_i >0
      #     OrderBurrito.create(order_id: @order.id, user_id: @user.id, burrito_id: @burrito.id, quantity: burrito[:quantity].to_i, item_price: @burrito.price)
      #   end
      #   # if it is in the order, check to see if the order quantity hads changed
      # elsif @current_item[0].quantity != burrito[:quantity].to_i
      #   # if it has, adjust quantiy
      #   @current_item[0].quantity = burrito[:quantity].to_i
      #   @current_item[0].save
      # end
    end
    if item_count < 1
      # if the order now contains 0 items go to error page
      redirect '/errors/orders/blank_order'
    end
    #  go to order confirmation/preview page
    redirect "/orders/preview"
  end
  
  post "/orders/complete" do
    # after user confirms order, remove order number from @user
    @user.order_ids = nil
    @user.save
    Burrito.all.each do |burrito|
      burrito.quantity = nil
      burrito.save
    end
    # go back to user index page
    redirect "/users/index"
  end
  
  delete '/order/:id' do
    # delete requested order and return to user index
    @order = Order.delete(params[:id])
    redirect "/users/index"
  end

end
