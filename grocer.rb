 require 'pry'
  # let(:items) do
  #   [
  #     {:item => "AVOCADO", :price => 3.00, :clearance => true},
  #     {:item => "KALE", :price => 3.00, :clearance => false},
  #     {:item => "BLACK_BEANS", :price => 2.50, :clearance => false},
  #     {:item => "ALMONDS", :price => 9.00, :clearance => false},
  #     {:item => "TEMPEH", :price => 3.00, :clearance => true},
  #     {:item => "CHEESE", :price => 6.50, :clearance => false},
  #     {:item => "BEER", :price => 13.00, :clearance => false},
  #     {:item => "PEANUTBUTTER", :price => 3.00, :clearance => true},
  #     {:item => "BEETS", :price => 2.50, :clearance => false},
  #     {:item => "SOY MILK", :price => 4.50, :clearance => true}
  #   ]
  # end

  # let(:coupons) do
  #   [
  #     {:item => "AVOCADO", :num => 2, :cost => 5.00},
  #     {:item => "BEER", :num => 2, :cost => 20.00},
  #     {:item => "CHEESE", :num => 3, :cost => 15.00}
  #   ]
  # end

def find_item_by_name_in_collection(name, collection)
  # Implement me first!
  #
  # Consult README for inputs and outputs
# * Arguments:
#   * `String`: name of the item to find
#   * `Array`: a collection of items to search through
# * Returns:
#   * `nil` if no match is found
#   * the matching `Hash` if a match is found between the desired name and a given
#     `Hash`'s :item key
  i = 0
  while i < collection.length do
    if collection[i][:item] == name
      return collection[i]
    else
      nil
    end
    i += 1
  end
end

def consolidate_cart(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
# * Arguments:
#   * `Array`: a collection of item Hashes
# * Returns:
#   * a ***new*** `Array` where every ***unique*** item in the original is present
#     * Every item in this new `Array` should have a `:count` attribute
#     * Every item's `:count` will be _at least_ one
#     * Where multiple instances of a given item are seen, the instance in the
#       new `Array` will have its `:count` increased
  i = 0
  new_cart = []
  while i < cart.length do
    item_name = cart[i][:item]
    item_new_cart = find_item_by_name_in_collection(item_name, new_cart)
    if item_new_cart  == nil # if item name is not found in new_cart, add item with :count => 1
      cart_item = find_item_by_name_in_collection(item_name, cart)
      new_item_info = {
        item: cart_item[:item],
        price: cart_item[:price],
        clearance: cart_item[:clearance]
      }
      new_item_info[:count] = 1
      new_cart << new_item_info
    else # if item name is found in new_cart, increase count by 1
      new_item_info[:count] += 1
    end
    i+=1
  end
  new_cart
end

# def apply_coupons(cart, coupons)
#   Consult README for inputs and outputs
  
#   REMEMBER: This method **should** update cart
# * Arguments:
#   * `Array`: a collection of item `Hash`es
#   * `Array`: a collection of coupon `Hash`es
# * Returns:
#   * A ***new*** `Array`. Its members will be a mix of the item `Hash`es and,
#     where applicable, the "ITEM W/COUPON" `Hash`. Rules for application are
#     described below.

# Case 1: coupon for item 1:1
# Case 2: coupon for item where more multiple items required (split discount between items)
# Case 3: no coupons
# Case 4: coupons for no items
# Loop 1 & 2 for multiple coupons

# ex. coupons = [{:item => "AVOCADO", :num => 2, :cost => 5.00}]

#   coupon_cart = []
#   i = 0
#   while i < cart.length do
#     item_name = cart[i][:item]
#     item_info = find_item_by_name_in_collection(item_name, cart)
#     coupon = find_item_by_name_in_collection(item_name, coupons)
#     if coupon != nil && coupon[:num] <= item_info[:count]
#       item_w_coupon = {
#         item: "#{item_name} W/ COUPON",
#         price: (coupon[:cost] / coupon[:num]),
#         clearance: item_info[:clearance],
#         count: coupon[:num]
#       }
#       item_info[:count] -= coupon[:num] # decrease item count
#       coupon_cart << item_w_coupon
#       if item_info[:count] = !0
#         coupon_cart << item_info
#       end
#     else
#       coupon_cart << item_info
#     end
#     i += 1
#   end 
#   coupon_cart
# end

def apply_coupons(cart, coupons)
  i = 0
  while i < coupons.length
    item_name = coupons[i][:item]
    coupon_name = "#{item_name} W/COUPON"
    cart_item = find_item_by_name_in_collection(item_name, cart)
    coupon_item = find_item_by_name_in_collection(coupon_name, cart)
    if coupon_item && coupons[i][:num] <= cart_item[:count]
      coupon_item[:count] += coupons[i][:num]
      cart_item[:count] -= coupons[i][:num]
    elsif !coupon_item
      coupon_item = {
      item: coupon_name,
      price: (coupons[i][:cost] / coupons[i][:num]),
      clearance: cart_item[:clearance],
      count: coupons[i][:num]
      }
      cart << coupon_item
      cart_item[:count] -= coupons[i][:num]
    else
    end
    i += 1
  end
  cart
end

def apply_clearance(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  
# * Arguments:
#   * `Array`: a collection of item `Hash`es
# * Returns:
#   * a ***new*** `Array` where every ***unique*** item in the original is present
#     *but* with its price reduced by 20% if its `:clearance` value is `true`
  i = 0
  while i < cart.length do
    if cart[i][:clearance] == true
      cart[i][:price] = (cart[i][:price]*0.8).round(2)
    end
  i += 1
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(consolidated_cart,coupons)
  applied_cart = apply_clearance(coupon_cart)
  i = 0
  total = 0
  while i < applied_cart.length
    qty = applied_cart[i][:count]
    price = applied_cart[i][:price]
    total += qty * price
    i+=1
  end
  if total > 100
    total *= 0.9
  else
    total
  end
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
end