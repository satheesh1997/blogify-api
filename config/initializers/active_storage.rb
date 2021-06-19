# frozen_string_literal: true

require "blogify_image_analyzer"

Rails.application.configure do
  config.active_storage.analyzers = [
    BlogifyImageAnalyzer,
    ActiveStorage::Analyzer::VideoAnalyzer
  ]
end
