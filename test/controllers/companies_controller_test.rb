require "test_helper"
require "application_system_test_case"

class CompaniesControllerTest < ApplicationSystemTestCase

  def setup
    @company = companies(:hometown_painting)
  end

  test "Index" do
    visit companies_path

    assert_text "Companies"
    assert_text "Hometown Painting"
    assert_text "Wolf Painting"
  end

  test "Show" do
    visit company_path(@company)

    zip_info = ZipCodes.identify(@company.zip_code)
    assert_text @company.name
    assert_text @company.phone
    assert_text @company.email
    assert_text "#{zip_info[:city]}, #{zip_info[:state_name]}"
  end

  test "In Show if zipcode is invalid" do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: "123456")
      click_button "Update Company"
    end

    visit company_path(@company)

    zip_info = ZipCodes.identify(@company.zip_code)
    assert_text "Please update the ZipCode of this company record with 5 Digit US postal code" if zip_info.nil?
  end

  test "Destroy" do
    visit company_path(@company)

    @company.destroy
    assert_equal nil, Company.find_by_id(@company.id)
  end

  test "Update" do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: "93009")
      click_button "Update Company"
    end

    assert_text "Changes Saved"

    @company.reload
    assert_equal "Updated Test Company", @company.name
    assert_equal "93009", @company.zip_code
  end

  test "Create" do
    visit new_company_path

    within("form#new_company") do
      fill_in("company_name", with: "New Test Company")
      fill_in("company_zip_code", with: "28173")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "new_test_company@getmainstreet.com")
      click_button "Create Company"
    end

    assert_text "Saved"

    last_company = Company.last
    assert_equal "New Test Company", last_company.name
    assert_equal "28173", last_company.zip_code
  end

  test "Validate email domain while creating the record" do
    visit new_company_path

    within("form#new_company") do
      fill_in("company_name", with: "New Test Company")
      fill_in("company_zip_code", with: "28173")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "new_test_company@xyz.com")
      click_button "Create Company"
    end

    assert_text 'invalid email address'
  end

  test "Validate email domain while Updating the record" do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: "93009")
      fill_in("company_email", with: "test_company@test.com")
      click_button "Update Company"
    end

    assert_text "invalid email address"
  end

  test "Validate email domain while Updating/creating the record without domain" do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: "93009")
      fill_in("company_email", with: "test")
      click_button "Update Company"
    end

    assert_text "invalid email address"
  end

  test "Validate email domain while Updating/creating the record with empty email id" do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: "93009")
      fill_in("company_email", with: "")
      click_button "Update Company"
    end

    assert_text "Changes Saved"

    @company.reload
    assert_equal "Updated Test Company", @company.name
    assert_equal "93009", @company.zip_code
    assert_equal "", @company.email
  end

end
