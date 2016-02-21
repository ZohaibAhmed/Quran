# Quran 

The idea behind this gem was to provide a simple way for Ruby applications to access the contents of the Quran. Note, that this gem is still in its preliminary stages and there is still a lot of work to be done to provide more complex queries into the Quran.

## Installation

```
gem install quran
```

## Usage

Supported Languages:

* English: 'en'
* Arabic: 'ar'
* Hindi: 'hi'
* Urdu: 'ur'

```ruby
require 'quran'
q = Quran.new ['en', 'ar']
```

#### get

```ruby
q.get(5, 8)
=> {"chapter"=>5, "verse"=>8, "en"=>"O you who believe! Be upright for Allah, bearers of witness with justice, and let not hatred of a people incite you not to act equitably; act equitably, that is nearer to piety, and he careful of (your duty to) Allah; surely Allah is Aware of what you do.", "translator"=>"shakir"}
```

#### get_chapter

```ruby
q.get_chapter(5, 8, lang='ar')
=> [{"chapter"=>112, "verse"=>1, "ar"=>"بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ قُلْ هُوَ ٱللَّهُ أَحَدٌ"}, {"chapter"=>112, "verse"=>2, "ar"=>"ٱللَّهُ ٱلصَّمَدُ"}, {"chapter"=>112, "verse"=>3, "ar"=>"لَمْ يَلِدْ وَلَمْ يُولَدْ"}, {"chapter"=>112, "verse"=>4, "ar"=>"وَلَمْ يَكُن لَّهُۥ كُفُوًا أَحَدٌۢ"}]
```

#### juz

```ruby
q.juz(4)
=> {:name=>"W-al-muḥṣanāt", :start_chapter=>4, :start_verse=>24, :end_chapter=>4, :end_verse=>147}
```

#### search

```ruby
q.search('sin and aggression')
=> [{"chapter"=>5, "verse"=>2, "en"=>"O you who believe! do not violate the signs appointed by Allah nor the sacred month, nor (interfere with) the offerings, nor the sacrificial animals with garlands, nor those going to the sacred house seeking the grace and pleasure of their Lord; and when you are free from the obligations of the pilgrimage, then hunt, and let not hatred of a people-- because they hindered you from the Sacred Masjid-- incite you to exceed the limits, and help one another in goodness and piety, and do not help one another in sin and aggression; and be careful of (your duty to) Allah; surely Allah is severe in requiting (evil).", "translator"=>"shakir"}]
```

## Command Line Tool

This gem ships with a command line tool. To get help, run:

```
quran -h
```

## Tests

```
rake test
```

## Credits

This would not have been possible without the Quran Text and Translations provided by http://tanzil.net. Looking for a [Javascript alternative?](https://github.com/qzaidi/quran/)

