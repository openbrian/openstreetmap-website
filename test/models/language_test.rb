require "test_helper"

class LanguageTest < ActiveSupport::TestCase
  def test_name
    assert_equal "Slovenian (Slovenščina)", Language.find("sl").name
  end

  def test_count
    assert_equal 197, Language.count
    assert_not_nil Language.find("zh")
  end
end
