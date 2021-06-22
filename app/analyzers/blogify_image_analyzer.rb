# frozen_string_literal: true

class BlogifyImageAnalyzer < ActiveStorage::Analyzer::ImageAnalyzer
  def metadata
    read_image do |image|
      if rotated_image?(image)
        { width: image.height, height: image.width }
      else
        { width: image.width, height: image.height }
      end.merge blurhash(image)
    end
  end

  private
    def blurhash(image)
      thumbnail = image.resize("200x200>").auto_orient
      {
        blurhash: Blurhash.encode(
          thumbnail.width,
          thumbnail.height,
          thumbnail.get_pixels.flatten
        )
      }
    rescue MiniMagick::Invalid => e
      logger.error "Error while encoding BlurHash: #{e}"
      {}
    end
end
