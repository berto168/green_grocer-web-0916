def consolidate_cart(cart)
  hash = {}
  cart.each do |data|
    data.each do |item, info|
      if hash.include?(item)
        hash[item][:count] += 1
      else
        hash[item] = info
        hash[item][:count] = 1
      end
    end
  end
  hash
end

def apply_coupons(cart, coupons)
  hash = {}
  coupons_used = []
  cart.each do |item, info|
    coupons.each do |coupon|
      if item == coupon[:item] && coupon[:num] <= info[:count]
        coupons_used << coupon
        coupon_count = coupons_used.inject(Hash.new(0)) { |total, x| total[x] += 1 ;total}
        hash[coupon[:item] + " W/COUPON"] = {
          :price => coupon[:cost],
          :clearance => info[:clearance],
          :count => coupon_count[coupon]
        }
        info[:count] = info[:count] - coupon[:num]
      end
    end
  end
  cart.merge(hash)
end

def apply_clearance(cart)
  cart.each do |item, info|
    if info[:clearance] == true
      info[:price] = (info[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  total_cost = 0
  consolidated_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(consolidated_cart, coupons)
  clearance_cart = apply_clearance(coupon_cart)
  clearance_cart.each do |item, info|
    cost = info[:price] * info[:count]
    total_cost += cost
  end
  if total_cost > 100
    total_cost = total_cost * 0.9
  end
  total_cost
end
