require 'minitest/autorun'
require 'quran'

class QuranTest < MiniTest::Unit::TestCase
  def setup
    @q = Quran.new ['en']
  end

  def test_get
    # Get Valid Verses
    assert_equal "In the name of Allah, the Beneficent, the Merciful.",
      @q.get(1,1)['en']

    assert_equal "And when there are present at the division the relatives and the orphans and the needy, give them (something) out of it and speak to them kind words.",
      @q.get(4, 8)['en']

    # Verse not found
    assert_raises(RuntimeError) {
      @q.get(2, -1)
    }

    # Chapter not found
    assert_raises(RuntimeError) {
      @q.get(300,200)['en']
    }
  end

  def test_get_chapter
    assert_equal 7,
      @q.get_chapter(1).length

    assert_equal nil,
      @q.get_chapter(444)

    assert_equal nil,
      @q.get_chapter(-2)
  end

  def test_juz
    assert_equal "Sayaqūl",
      @q.juz(1)[:name]

    assert_equal 4,
      @q.juz(5)[:start_chapter]

    assert_equal nil,
      @q.juz(66)

    # Second last
    assert_equal "Tabāraka -lladhi",
      @q.juz(-2)[:name]
  end

  def test_search
    assert_equal 15,
      @q.search("happy").length

    assert_equal 52,
      @q.search("isa").length

    assert_equal 0,
      @q.search("potatoes").length
  end
end