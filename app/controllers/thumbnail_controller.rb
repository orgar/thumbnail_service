require "open-uri"
require 'mini_magick'
require 'fileutils'

class ThumbnailController < ApplicationController
  BACKGROUND_COLOR = 'black'

# TODO to add comments

  # GET /thumbnail
  def ipad_thumbnail

    validation_ans = validate_params
    return render json: {message: validation_ans}, status: 400 if validation_ans

    # TODO its double do I want this for the returned code ? probebly not
    download = download_file params[:url]
    if download[:exception]
      render json: { message: "Fail to download file from url. #{download[:exception].message}", backtrace: download[:exception].backtrace}, status: 400
    end

    begin
      image =  MiniMagick::Image.open(download[:filename])
      FileUtils.rm(download[:filename])
    rescue Exception => e
      render json: { message: "Fail to open image", backtrace: e.backtrace}, status: 500
      return
    end

    begin
      ratio = [
        get_ipad_ratio(image[:width], params[:width]),
        get_ipad_ratio(image[:height], params[:height])
      ].min

      new_image_name = "#{get_random_string}-#{params[:width]}-#{params[:height]}.jpeg"

      image.combine_options do |c|
        c.resize("#{(image[:width]*ratio).to_i}x#{(image[:height]*ratio).to_i}")
        c.background(BACKGROUND_COLOR)
        c.gravity('center')
        c.extent "#{params[:width]}x#{params[:height]}"
      end
      image.format "jpeg"
      image.write "storage/#{new_image_name}"

      send_file("storage/#{new_image_name}",
        :filename => "thumbnail-#{params[:width]}-#{params[:height]}.jpeg",
        :type => "mime/type")
    rescue Exception => e
      render json: { message: "Fail to manipulate the image", backtrace: e.backtrace}, status: 500
      return
    end
  end


  private
  def get_ipad_ratio original, wanted
    return 1 if wanted.to_i > original
    return wanted.to_f / original.to_f
  end

  def validate_params
    return "Missing one of the following parameters: url, width, height" unless params[:url] && params[:width] && params[:height]
    return "Width is invalid" if !/\A\d+\z/.match(params[:width])
    return "Height is invalid" if !/\A\d+\z/.match(params[:height])
  end

# TODO maybe give the filename
  def download_file url
    begin
      filename = get_random_string + ".photo"
      open(url) { |f| File.open(filename ,"wb") { |file| file.puts f.read } }
      {filename: filename}
    rescue Exception => e
      {exception: e}
    end
  end

  def get_random_string
    "#{[*('a'..'z')].sample(12).join}#{Time.new.to_i.to_s}"
  end

end
