require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do

  describe "#initialize" do
    # it "does called on object creation" COMMENT: already tested with case:8

    it "does assign items into instance variable" do
      items = [Item.new(name="+5 Dexterity Vest", sell_in=10, quality=20)]
      gilded_rose = GildedRose.new(items)
      expect(gilded_rose.instance_variable_get(:@items)).to eq items
    end
  end

  describe "#update_quality" do
    it 'does NOT change the name' do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].name).to eq "foo"
    end

    context 'when 1 day passed' do
      context 'when item is NOT belongs to any special category' do
        five_dexterity_vest = Item.new(name="+5 Dexterity Vest", sell_in=10, quality=20)

        context "when sell by date has NOT been passed" do
          GildedRose.new([five_dexterity_vest]).update_quality

          it 'does degrades quality by 1' do
            expect(five_dexterity_vest.quality).to eq 19
          end

          it 'does degrades sell in days by 1' do
            expect(five_dexterity_vest.sell_in).to eq 9
          end
        end

        context 'when sell by date has been passed' do
          before do
            five_dexterity_vest.sell_in = -1
            GildedRose.new([five_dexterity_vest]).update_quality
          end

          it 'does degrades quality by 2 i.e 17' do
            expect(five_dexterity_vest.quality).to eq 17
          end

          it 'does degrades sell in days by 1 i.e -2' do
            expect(five_dexterity_vest.sell_in).to eq -2
          end
        end

        context 'when quality is already 0' do
          before do
            five_dexterity_vest.quality = 0
            GildedRose.new([five_dexterity_vest]).update_quality
          end
          it 'does NOT degrades quality anymore i.e. remains 0' do
            expect(five_dexterity_vest.quality).to eq 0
          end
        end
      end

      context "when item name is 'Aged Brie'" do
        aged_brie = Item.new(name="Aged Brie", sell_in=4, quality=5)
        context "when sell by date has NOT been passed" do
          GildedRose.new([aged_brie]).update_quality
          it 'does increase in Quality by 1 i.e. 6' do
            expect(aged_brie.quality).to eq 6
          end
        end

        context "when sell by date has been passed" do
          before do
            aged_brie.sell_in = 0
            GildedRose.new([aged_brie]).update_quality
          end
          it 'does increase in Quality by 2 i.e. 8' do
            expect(aged_brie.quality).to eq 8
          end
        end
      end

      context "when item name is 'Sulfuras, Hand of Ragnaros'" do
        sulfuras = Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=1, quality=80)
        GildedRose.new([sulfuras]).update_quality

        it 'does never change in quality i.e. 80' do
          expect(sulfuras.quality).to eq 80
        end

        it 'does never change in sell in days i.e. 1' do
          expect(sulfuras.sell_in).to eq 1
        end
      end

      context "when item name is 'Backstage passes to a TAFKAL80ETC concert'" do
        backstage_passes = Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=15, quality=20)

        context "when sell by date has NOT been passed" do
          context 'when sell in days are more than 10' do
            before do
              GildedRose.new([backstage_passes]).update_quality
            end
            it 'does increment quality by 1 i.e. 21' do
              expect(backstage_passes.quality).to eq 21
            end
          end

          context 'when sell in days are 10' do
            before do
              backstage_passes.sell_in = 10
              GildedRose.new([backstage_passes]).update_quality
            end
            it 'does increment quality by 2 i.e. 23' do
              expect(backstage_passes.quality).to eq 23
            end
          end

          context 'when sell in days are less than 10 and more than 5' do
            before do
              backstage_passes.sell_in = 7
              GildedRose.new([backstage_passes]).update_quality
            end
            it 'does increment quality by 2 i.e. 25' do
              expect(backstage_passes.quality).to eq 25
            end
          end

          context 'when sell in days are 5' do
            before do
              backstage_passes.sell_in = 5
              GildedRose.new([backstage_passes]).update_quality
            end
            it 'does increment quality by 3 i.e. 28' do
              expect(backstage_passes.quality).to eq 28
            end
          end

          context 'when sell in days are less than 5' do
            before do
              backstage_passes.sell_in = 4
              GildedRose.new([backstage_passes]).update_quality
            end
            it 'does increment quality by 3 i.e. 31' do
              expect(backstage_passes.quality).to eq 31
            end
          end
        end

        context "when sell by date has been passed" do
          before do
            backstage_passes.sell_in = -1
            GildedRose.new([backstage_passes]).update_quality
          end
          it 'does change to 0' do
            expect(backstage_passes.quality).to eq 0
          end
        end
      end

      context "when item name is 'Conjured'" do
        conjured = Item.new(name="Conjured Mana Cake", sell_in=3, quality=10)
        context "when sell by date has NOT been passed" do
          GildedRose.new([conjured]).update_quality
          it 'does update the quantity by 2 i.e. 8' do
            expect(conjured.quality).to eq 8
          end
        end
        context "when sell by date has been passed" do
          before do
            conjured.sell_in = -1
            GildedRose.new([conjured]).update_quality
          end
          it 'does update the quantity by 4 i.e. 4' do
            expect(conjured.quality).to eq 4
          end
        end
      end
    end
  end
end
