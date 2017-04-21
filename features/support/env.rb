require 'rspec'
require 'page-object'
require 'fig_newton'
require 'require_all'
require 'parallel_tests'
require 'selenium-webdriver'
require 'watir'
require 'rest-client'
require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'uri'
require 'webdriver-user-agent'
require 'date'
require 'gmail'
require 'csv'

World(PageObject::PageFactory)

def download_all
  (ENV['DL_ALL'] ||= 'false').downcase.to_sym
end

def ig_id
  Array((ENV['IGID']))
end
