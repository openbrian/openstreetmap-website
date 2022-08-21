require "test_helper"
require "minitest/mock"

class MicrocosmsControllerTest < ActionDispatch::IntegrationTest
  ##
  # test all routes which lead to this controller
  def test_routes
    assert_routing(
      { :path => "/microcosms", :method => :get },
      { :controller => "microcosms", :action => "index" }
    )
    assert_routing(
      { :path => "/microcosms/1", :method => :get },
      { :controller => "microcosms", :action => "show", :id => "1" }
    )
    assert_routing(
      { :path => "/microcosms/mdc", :method => :get },
      { :controller => "microcosms", :action => "show", :id => "mdc" }
    )
  end

  def test_index_get
    m = create(:microcosm)
    get microcosms_path
    check_page_basics
    assert_template "index"
    assert_match m.name, response.body
  end

  def test_show_get
    m = create(:microcosm)
    get microcosm_path(m)
    check_page_basics
    assert_template("show")
    assert_match m.name, response.body
    assert_match m.description, response.body
  end

  def test_update_put_success
    # TODO: When microcosm_member is created switch to using that factory.
    # arrange
    session_for(create(:administrator_user))
    m1 = create(:microcosm) # original object
    m2 = build(:microcosm) # new data
    # act
    put microcosm_url(m1), :params => { :microcosm => m2.as_json }, :xhr => true
    # assert
    assert_redirected_to microcosm_path(m1)
    # TODO: Is it better to use t() to translate?
    assert_equal I18n.t("microcosms.update.success"), flash[:notice]
    m1.reload
    # Assign the id of m1 to m2, so we can do an equality test easily.
    m2.id = m1.id
    assert_equal(m2, m1)
  end

  def test_update_put_failure
    # TODO: When microcosm_member is created switch to using that factory.
    # arrange
    session_for(create(:administrator_user))
    m1 = create(:microcosm) # original object
    def m1.update(_params)
      false
    end

    controller_mock = MicrocosmsController.new
    def controller_mock.set_microcosm
      @microcosm = Microcosm.new
    end

    def controller_mock.render(_)
      # Can't do assert_equal here.
      # assert_equal :edit, partial
    end

    # act
    MicrocosmsController.stub :new, controller_mock do
      Microcosm.stub :new, m1 do
        assert_difference "Microcosm.count", 0 do
          put microcosm_url(m1), :params => { :microcosm => m1.as_json }, :xhr => true
        end
      end
    end

    # assert
    assert_equal I18n.t("microcosms.update.failure"), flash[:alert]
  end

  def test_new_no_login
    # Make sure that you are redirected to the login page when you
    # are not logged in
    # act
    get new_microcosm_path
    # assert
    assert_response :redirect
    assert_redirected_to login_path(:referer => new_microcosm_path)
  end

  def test_new_form
    # Now try again when logged in
    # arrange
    session_for(create(:administrator_user))
    # act
    get new_microcosm_path
    # assert
    check_page_basics
    # assert_select "title", :text => /New Microcosm/, :count => 1
    assert_select "div.content-heading", :count => 1 do
      assert_select "h1", :text => /Microcosm/, :count => 1
    end
    assert_select "div#content", :count => 1 do
      assert_select "form[action='/microcosms'][method=post]", :count => 1 do
        assert_select "input#microcosm_location[name='microcosm[location]']", :count => 1
        assert_select "input#microcosm_lat[name='microcosm[lat]']", :count => 1
        assert_select "input#microcosm_lon[name='microcosm[lon]']", :count => 1
        assert_select "input#microcosm_min_lat[name='microcosm[min_lat]']", :count => 1
        assert_select "input#microcosm_max_lat[name='microcosm[max_lat]']", :count => 1
        assert_select "input#microcosm_min_lon[name='microcosm[min_lon]']", :count => 1
        assert_select "input#microcosm_max_lon[name='microcosm[max_lon]']", :count => 1
        assert_select "textarea#microcosm_description[name='microcosm[description]']", :count => 1
        assert_select "input", :count => 10
      end
    end
  end

  def test_create
    # arrange
    session_for(create(:administrator_user))
    m_orig = create(:microcosm)

    # act
    m_new_slug = nil
    assert_difference "Microcosm.count", 1 do
      post microcosms_url, :params => { :microcosm => m_orig.as_json }, :xhr => true
      m_new_slug = @response.headers["Location"].split("/")[-1]
    end

    # assert
    m_new = Microcosm.find_by(:slug => m_new_slug)
    # Assign the id m_new to m_orig, so we can do an equality test easily.
    m_orig.id = m_new.id
    assert_equal(m_orig, m_new)
  end
end
