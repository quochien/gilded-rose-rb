require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe '#update_quality' do
    it 'does not change the name' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq 'foo'
    end

    it 'The Quality of an item is never negative' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq(0)
    end

    it 'The Quality of an item is never more than 50' do
      items = [Item.new('Aged Brie', 0, 50)]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq(50)
    end

    context 'normal item' do
      let(:item1) { Item.new('+5 Dexterity Vest', 10, 12) }
      let(:items) { [item1] }
      let(:gilded_rose) { GildedRose.new(items) }

      it 'degrades quality by 1' do
        gilded_rose.update_quality
        expect(item1.quality).to eq(11)
      end

      it 'degrades sell_in by 1' do
        gilded_rose.update_quality
        expect(item1.sell_in).to eq(9)
      end

      it 'Once the sell by date has passed, Quality degrades twice as fast' do
        10.times { gilded_rose.update_quality }
        expect(item1.quality).to eq(2)
        expect(item1.sell_in).to eq(0)

        gilded_rose.update_quality
        expect(item1.quality).to eq(0)
        expect(item1.sell_in).to eq(-1)

        gilded_rose.update_quality
        expect(item1.quality).to eq(0)
        expect(item1.sell_in).to eq(-2)
      end
    end

    context 'Aged Brie item' do
      let(:item1) { Item.new('Aged Brie', 2, 0) }
      let(:items) { [item1] }
      let(:gilded_rose) { GildedRose.new(items) }

      it 'increases quality' do
        gilded_rose.update_quality
        expect(item1.sell_in).to eq(1)
        expect(item1.quality).to eq(1)

        gilded_rose.update_quality
        expect(item1.sell_in).to eq(0)
        expect(item1.quality).to eq(2)

        gilded_rose.update_quality
        expect(item1.sell_in).to eq(-1)
        expect(item1.quality).to eq(4)

        gilded_rose.update_quality
        expect(item1.sell_in).to eq(-2)
        expect(item1.quality).to eq(6)
      end
    end

    context 'Sulfuras item' do
      let(:item1) { Item.new('Sulfuras, Hand of Ragnaros', 0, 80) }
      let(:items) { [item1] }
      let(:gilded_rose) { GildedRose.new(items) }

      before do
        80.times { gilded_rose.update_quality }
      end

      it 'never has to be sold or decreases in Quality' do
        expect(item1.quality).to eq(80)
        expect(item1.sell_in).to eq(0)
      end
    end

    context 'Backstage passes item' do
      let(:item1) { Item.new('Backstage passes to a TAFKAL80ETC concert', 15, 20) }
      let(:items) { [item1] }
      let(:gilded_rose) { GildedRose.new(items) }

      it 'increases quality by 1 when there are more than 10 days' do
        item1.sell_in = 12

        gilded_rose.update_quality
        expect(item1.sell_in).to eq(11)
        expect(item1.quality).to eq(21)

        gilded_rose.update_quality
        expect(item1.sell_in).to eq(10)
        expect(item1.quality).to eq(22)
      end

      it 'increases quality by 2 when there are 10 days or less' do
        item1.sell_in = 10

        gilded_rose.update_quality
        expect(item1.sell_in).to eq(9)
        expect(item1.quality).to eq(22)

        gilded_rose.update_quality
        expect(item1.sell_in).to eq(8)
        expect(item1.quality).to eq(24)
      end

      it 'increases quality by 3 when there are 5 days or less' do
        item1.sell_in = 5

        gilded_rose.update_quality
        expect(item1.sell_in).to eq(4)
        expect(item1.quality).to eq(23)

        gilded_rose.update_quality
        expect(item1.sell_in).to eq(3)
        expect(item1.quality).to eq(26)
      end

      it 'drops quality to 0 after the concert' do
        item1.sell_in = 0

        gilded_rose.update_quality
        expect(item1.sell_in).to eq(-1)
        expect(item1.quality).to eq(0)

        gilded_rose.update_quality
        expect(item1.sell_in).to eq(-2)
        expect(item1.quality).to eq(0)
      end
    end

    context 'Conjured item' do
      let(:item1) { Item.new('Conjured Mana Cake', 2, 6) }
      let(:items) { [item1] }
      let(:gilded_rose) { GildedRose.new(items) }

      it 'degrades in Quality twice as fast as normal items' do
        gilded_rose.update_quality
        expect(item1.sell_in).to eq(1)
        expect(item1.quality).to eq(4)

        gilded_rose.update_quality
        expect(item1.sell_in).to eq(0)
        expect(item1.quality).to eq(2)

        gilded_rose.update_quality
        expect(item1.sell_in).to eq(-1)
        expect(item1.quality).to eq(0)
      end
    end
  end
end
