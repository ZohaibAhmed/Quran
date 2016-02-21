# The Main Quran class that allows querying.
# 
#   @todo: I eventually want to have a Translator class that can
#   abstract different translations once we can find them. That
#   way, a user can query and retrive different translations and
#   tafsirs of a verse.
# 
# @author Zohaib Ahmed
# @since 0.0.1
class Quran
  require "sqlite3"

  # Initialize the Quran with the language(s) specified.
  #
  # @param langs [Array]
  #
  # @example
  #   quran = Quran.new ['en', 'ar']
  def initialize(langs=['ar'])
    db = SQLite3::Database.new "lib/qurandb"
    db.results_as_hash = true

    @chapters = construct_dict(db, 'chapters', 'id')
    @languages = {}
    @default_lang = langs[0]

    possible_langs = ['en', 'ar', 'hi', 'uz', 'ur']
    langs.each do |lang|
      if possible_langs.include? lang
        @languages[lang] = construct_dict(db, lang, 'chapter')
      else
        raise "The language you asked for isn't supported yet."
      end
    end

    @juz = [
      {:name => "Alif-Lam-Mim", :start_chapter => 1, :start_verse => 1, :end_chapter => 2, :end_verse => 141},
      {:name => "Sayaqūl", :start_chapter => 2, :start_verse => 142, :end_chapter => 2, :end_verse => 252},
      {:name => "Tilka -r-rusul", :start_chapter => 2, :start_verse => 253, :end_chapter => 3, :end_verse => 92},
      {:name => "Lan Tana Lu", :start_chapter => 3, :start_verse => 93, :end_chapter => 4, :end_verse => 23},
      {:name => "W-al-muḥṣanāt", :start_chapter => 4, :start_verse => 24, :end_chapter => 4, :end_verse => 147},
      {:name => "Lā yuẖibbu-llāh", :start_chapter => 4, :start_verse => 148, :end_chapter => 5, :end_verse => 81},
      {:name => "Wa ʾidha samiʿū", :start_chapter => 5, :start_verse => 82, :end_chapter => 6, :end_verse => 110},
      {:name => "Wa law ʾannanā", :start_chapter => 6, :start_verse => 111, :end_chapter => 7, :end_verse => 87},
      {:name => "Qāl al-malāʾ", :start_chapter => 7, :start_verse => 88, :end_chapter => 8, :end_verse => 40},
      {:name => "W-aʿlamū", :start_chapter => 8, :start_verse => 41, :end_chapter => 9, :end_verse => 92},
      {:name => "Yaʾtadhirūna", :start_chapter => 9, :start_verse => 93, :end_chapter => 11, :end_verse => 5},
      {:name => "Wa mā min dābbah", :start_chapter => 11, :start_verse => 6, :end_chapter => 12, :end_verse => 52},
      {:name => "Wa mā ʾubarriʾu", :start_chapter => 12, :start_verse => 53, :end_chapter => 14, :end_verse => 52},
      {:name => "ʾAlif Lām Rāʾ", :start_chapter => 15, :start_verse => 1, :end_chapter => 16, :end_verse => 128},
      {:name => "Subḥāna -lladhi", :start_chapter => 17, :start_verse => 1, :end_chapter => 18, :end_verse => 74},
      {:name => "Qāla ʾa-lam", :start_chapter => 18, :start_verse => 75, :end_chapter => 20, :end_verse => 135},
      {:name => "Aqtaraba li-n-nās", :start_chapter => 21, :start_verse => 1, :end_chapter => 22, :end_verse => 78},
      {:name => "Qad ʾaflaḥa", :start_chapter => 23, :start_verse => 1, :end_chapter => 25, :end_verse => 20},
      {:name => "Wa-qāla -lladhīna", :start_chapter => 25, :start_verse => 21, :end_chapter => 27, :end_verse => 55},
      {:name => "Am-man khalaq", :start_chapter => 27, :start_verse => 56, :end_chapter => 29, :end_verse => 45},
      {:name => "Utlu ma uhiya", :start_chapter => 29, :start_verse => 46, :end_chapter => 33, :end_verse => 30},
      {:name => "Wa-man yaqnut", :start_chapter => 33, :start_verse => 31, :end_chapter => 36, :end_verse => 27},
      {:name => "Wa-mā-liya", :start_chapter => 36, :start_verse => 28, :end_chapter => 39, :end_verse => 31},
      {:name => "Fa-man ʾaẓlamu", :start_chapter => 39, :start_verse => 21, :end_chapter => 41, :end_verse => 46},
      {:name => "ʾIlaihi yuraddu", :start_chapter => 41, :start_verse => 47, :end_chapter => 45, :end_verse => 37},
      {:name => "Ḥāʾ Mīm", :start_chapter => 46, :start_verse => 1, :end_chapter => 51, :end_verse => 30},
      {:name => "Qāla fa-mā khatbukum", :start_chapter => 51, :start_verse => 31, :end_chapter => 57, :end_verse => 29},
      {:name => "Qad samiʿa -llāhu", :start_chapter => 58, :start_verse => 1, :end_chapter => 66, :end_verse => 12},
      {:name => "Tabāraka -lladhi", :start_chapter => 67, :start_verse => 1, :end_chapter => 77, :end_verse => 50},
      {:name => "Fa-man ʾaẓlamu", :start_chapter => 78, :start_verse => 1, :end_chapter => 114, :end_verse => 6}
    ]

    return
  end

  # Initialize the Quran with the language(s) specified.
  #
  # @param chapter [String]
  # 
  #
  # @example
  #   quran = Quran.new ['en', 'ar']
  def get(chapter, verse, lang=@default_lang)
    if verse.nil?
      raise "Verse does not exist."
    end

    if verse < 1
      raise "Verse does not exist."
    end

    verses = @languages[lang][chapter]

    if verses.nil?
      raise "Chapter does not exist"
    end

    row = verses[verse - 1]

    if row.nil?
      raise "Verse does not exist."
    end

    return row
  end

  # Get the contents of the entire chapter.
  # 
  # @param chapter [Integer] the chapter number
  # @param lang [String] the language for the content
  # 
  # @return [Array] Array of hashes containing verses in the chapter  
  def get_chapter(chapter, lang=@default_lang)
    return @languages[lang][chapter]
  end


  # Get the details for a particular Juz
  # 
  # @param juz_number [Integer] the juz number
  # 
  # @return [Hash] details of the Juz
  def juz(juz_number)
    return @juz[juz_number]
  end


  # Return a list of hashes containing the verses that the search term
  # appears in.
  # 
  # @todo Add support for other languages here.
  # @todo Find a way to do more of a fuzzy search of a phrase as a term
  #   For example, the verse: 
  #     "Allah does not impose upon any soul a duty but to the extent of its ability"
  #   should be returned if the term was "impose any soul"
  # 
  # @param term [String] the search term
  # @param lang [String] the language for the content
  # 
  # @return [Array] Search results
  def search(term, lang=@default_lang)
    ret = []
    (1..114).each do |chapter|
      verses = get_chapter(chapter, lang)

      verses.each do |v|
        if v[lang].include? term
          ret << v
        end
      end
    end

    return ret
  end

  private
  # Construct a dict from a table in the db. The key is specified in key.
  # The values will be a dict that contains the rest of the columns in the table.
  # 
  # @param db [SQLite3]
  # @param table [String]
  # @param key [String]
  # 
  # @return [Hash]
  def construct_dict(db, table, key)
    query_str = "SELECT * FROM #{table}"
    final_hash = {}
    db.execute(query_str) do |row|
      hash_key = row[key]
      # get all the values
      vals = {}
      row.keys.each do |other_key|
        # if the other_key is a type string, take it, otherwise ignore.
        if other_key.is_a? String
          vals[other_key] = row[other_key]
        end
      end

      if final_hash.has_key?(hash_key)
        final_hash[hash_key] << vals
      else
        final_hash[hash_key] = [vals]
      end
    end
    return final_hash
  end
end


# 
# Extending the Array class.
# 
# @author [zohaibahmed]
# 
class Array
  # Search if search value is in string
  # @param search_value [String]
  # @param regex_format = '%s' [String]
  # 
  # @return [type] [description]  
  def fuzzy_include?(search_value, regex_format = '%s')
    inject(false) do |is_found, array_value|
      is_found or !!(search_value =~ /#{regex_format % array_value}/)
    end
  end

end
