class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      case item.name
      when 'Aged Brie'
        update_aged_brie(item)
      when 'Backstage passes to a TAFKAL80ETC concert'
        update_backstage_passes(item)
      when 'Sulfuras, Hand of Ragnaros'
        next # Sulfuras does not change
      else
        update_general_item(item)
      end

      update_sell_in(item)
    end
  end

  private

  def update_aged_brie(item)
    item.quality = [item.quality + 1, 50].min
  end

  def update_backstage_passes(item)
    if item.sell_in <= 0
      item.quality = 0
    elsif item.sell_in <= 5
      item.quality = [item.quality + 3, 50].min
    elsif item.sell_in <= 10
      item.quality = [item.quality + 2, 50].min
    else
      item.quality = [item.quality + 1, 50].min
    end
  end

  def update_general_item(item)
    quality_degradation = determine_quality_degradation(item)
    item.quality = calculate_updated_quality(item.quality, quality_degradation)
  end

  def update_sell_in(item)
    item.sell_in -= 1 unless item.name == 'Sulfuras, Hand of Ragnaros'
  end

  def determine_quality_degradation(item)
    base_degradation = 1
    additional_degradation(item) + base_degradation
  end

  def additional_degradation(item)
    return 1 if item.sell_in <= 0
    0
  end

  def calculate_updated_quality(current_quality, degradation_amount)
    [current_quality - degradation_amount, 0].max
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
