require "pry"


def consolidate_cart(cart)
 new_hash={}
 cart.each do |element_hash|
   element_name = element_hash.keys[0]
   
   if new_hash.has_key?(element_name)
    new_hash[element_name][:count] += 1
   
   else new_hash[element_name] = { 
     count: 1,
     price: element_hash[element_name][:price],
     clearance: element_hash[element_name][:clearance]
   }
     
    end
  end
return new_hash
end


def apply_coupons(cart, coupons)
   
   coupons.each do |coupon|
    item = coupon[:item]
    if cart[item] 
     
      if cart[item][:count] >= coupon[:num] && !cart["#{item} W/COUPON"]
       cart["#{item} W/COUPON"] = {price: coupon[:cost] /coupon[:num] , clearance: cart[item][:clearance] , count: coupon[:num] }
       cart[item][:count] -= coupon[:num]
       
     elsif cart[item][:count] >= coupon[:num] && cart["#{item} W/COUPON"]
           cart["#{item} W/COUPON"][:count] += coupon[:num]
           cart[item][:count] -= coupon[:num]
   end
   end
  end 
  return cart
end




def apply_clearance(cart)
 cart.each do |item , info|
 info[:price] -= info[:price] * 0.2 if info[:clearance] == true
 end
 return cart
end

def checkout(cart, coupons)
  hash = consolidate_cart(cart)
  coupon_discounts = apply_coupons(hash, coupons)
  clearance = apply_clearance(coupon_discounts)
  
 total = clearance.reduce(0) {| acc, (key, value)| acc += value[:price] * value[:count] }
 total > 100 ? total * 0.9 : total
 
 end
