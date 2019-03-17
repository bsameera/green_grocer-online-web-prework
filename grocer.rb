require 'pry'
def consolidate_cart(cart)
  # code here
  items = []
  new_hash = {}
  count_hash = {}
  cart.each do |item_hash|
    item_hash.each do |key, val|
      items.push(key)
    end 
  end
  items.uniq.each do |item|
    cart.each do |item_hash|
      item_hash.each do |key, val|
        if item == key
          new_hash[item] = val
        end 
      end
    end 
  end 
  items.each do |x|
    if count_hash[x] == nil 
      count_hash[x] = { :count => 1 }
    else 
      count = count_hash[x][:count] + 1
      count_hash[x] = { :count => count }
    end 
  end 
  items.each do |x|
    new_hash[x] = new_hash[x].merge(count_hash[x])
  end 
  #binding.pry
  new_hash
end

def apply_coupons(cart, coupons)
  # code here
  coupons_hash = {}
  cart_items = []
  coupon_items = []
  cart.each do |key, val|
    cart_items.push(key)
  end 
  coupons.each do |coupon|
    coupon_items.push(coupon[:item])
  end
  coupons.each do |coupon|
    if cart_items.include?(coupon[:item])
      new_key = coupon[:item] + " W/COUPON"
      coupons_hash[new_key] = {
        :price => coupon[:cost],
        :clearance => cart[coupon[:item]][:clearance],
        :count => 1  
      }
      if coupon_items.count(coupon[:item]) > 1 
        coupons_hash[new_key][:count] = coupon_items.count(coupon[:item])
      end 
      count = cart[coupon[:item]][:count]
      if count < coupon[:num]
        coupons_hash[new_key][:count] += 1
        cart[coupon[:item]][:count] = coupon[:num] - count
      else   
        cart[coupon[:item]][:count] = count - coupon[:num]
      end 
    end 
  end 
  cart.merge(coupons_hash)
end

def apply_clearance(cart)
  # code here
  cart.each do |key, value|
    if value[:clearance] == true
      value[:price] = (value[:price] * 0.8).round(1)
    end 
  end 
  cart
end

def checkout(cart, coupons)
  # code here
  consolidated = consolidate_cart(cart)
  binding.pry
  if cart.length == 1 && coupons.length == 0   
    price = 0
    #consolidated = consolidate_cart(cart)
    coupons_applied = apply_coupons(consolidated, coupons)
    clearance_applied = apply_clearance(coupons_applied)
    clearance_applied.each {|key, val| price = val[:price]}
    return price
  end 
  
  if cart.length > 1 && coupons.length == 1 
    prices = []
    #consolidated = consolidate_cart(cart)
    coupons_applied = apply_coupons(consolidated, coupons)
    clearance_applied = apply_clearance(coupons_applied)
    clearance_applied.each { |key, val| 
      prices.push(val[:price]) }
    #binding.pry
    return prices.reduce { |total, n| total+n }
  end 
  
  if cart.length > 1 && coupons.length > 1
    prices = []
    #consolidated = consolidate_cart(cart)
    coupons_applied = apply_coupons(consolidated, coupons)
    clearance_applied = apply_clearance(coupons_applied)
    clearance_applied.each { |key, val| 
      prices.push(val[:price]) }
    #binding.pry
    return prices.reduce { |total, n| total+n }
  end 
  
end


