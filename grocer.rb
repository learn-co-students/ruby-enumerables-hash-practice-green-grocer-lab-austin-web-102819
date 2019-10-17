def consolidate_cart(cart)
  hash={}
  cart.each do |element|
    element_stats=element.keys[0]
    if hash[element_stats]
      hash[element_stats][:count]+=1
    else
      hash[element_stats]=element[element_stats]
      hash[element_stats][:count] = 1
    end
  end
  hash
end

def apply_coupons(cart, coupons) 
  coupons.each do |coupon| 
      name = coupon[:item]
      if cart[name]
      if cart[name][:count] >= coupon[:num] && !cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"] = {:price => coupon[:cost]/coupon[:num], :clearance => cart[name][:clearance], :count => coupon[:num]}
         cart[name][:count] -= coupon[:num]
      elsif cart[name][:count] >= coupon[:num] && cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += coupon[:num] 
         cart[name][:count] -= coupon[:num]
end
end
end
cart
end

def apply_clearance(cart)
  cart.each do |item, stats| 
    stats[:price] -= stats[:price] *0.2 unless !stats[:clearance]
  end
  cart
end

def checkout(cart, coupons)
  hash_cart= consolidate_cart(cart)
  applied_coupons= apply_coupons(hash_cart, coupons)
  apply_clear= apply_clearance(applied_coupons)
  total = apply_clear.reduce(0) { |sum, (key, value)| sum += value[:price]*value[:count]}
  total> 100? total * 0.9 : total
end
