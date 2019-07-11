class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      case type_of(item)
      when 'normal'
        update_quality_for_normal_item(item)
      when 'aged'
        update_quality_for_aged_item(item)
      when 'backstage'
        update_quality_for_backstage_item(item)
      when 'conjured'
        update_quality_for_conjured_item(item)
      end
    end
  end

  def type_of(item)
    aged_items = ['Aged Brie']
    sulfuras_items = ['Sulfuras, Hand of Ragnaros']
    backstage_items = ['Backstage passes to a TAFKAL80ETC concert']
    conjured_items = ['Conjured Mana Cake']

    return 'aged' if aged_items.include? item.name
    return 'sulfuras' if sulfuras_items.include? item.name
    return 'backstage' if backstage_items.include? item.name
    return 'conjured' if conjured_items.include? item.name

    'normal'
  end

  def update_quality_for_conjured_item(item)
    2.times { item.quality -= 1 if item.quality > 0 }
    item.sell_in -= 1
    2.times { item.quality -= 1 if item.quality > 0 } if item.sell_in < 0
  end

  def update_quality_for_backstage_item(item)
    item.quality += 1 if item.quality < 50
    item.quality += 1 if item.quality < 50 && item.sell_in < 11
    item.quality += 1 if item.quality < 50 && item.sell_in < 6

    item.sell_in -= 1
    item.quality = 0 if item.sell_in < 0
  end

  def update_quality_for_normal_item(item)
    item.quality -= 1 if item.quality > 0
    item.sell_in -= 1
    item.quality -= 1 if item.sell_in < 0 && item.quality > 0
  end

  def update_quality_for_aged_item(item)
    item.quality += 1 if item.quality < 50
    item.sell_in -= 1
    item.quality += 1 if item.sell_in < 0 && item.quality < 50
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
