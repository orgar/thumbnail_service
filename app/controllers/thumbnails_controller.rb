require 'mini_magick'

class ThumbnailsController < ApplicationController
  BACKGROUND_COLOR = 'black'

# TODO to add comments

  # GET /thumbnail
  def ipad_thumbnail

    validation_ans = validate_params params
    return render json: {message: validation_ans}, status: 400 if validation_ans

    begin
      image =  MiniMagick::Image.open(params[:url])
    rescue SocketError, URI::InvalidURIError => e
      render json: { message: "Url not found : #{e.message}", backtrace: e.backtrace}, status: 500
      return
    rescue MiniMagick::Invalid => e
      render json: { message: "Url is not an image", backtrace: e.backtrace}, status: 500
      return
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

  def is_alive
    render json: { message: "Hello, I'm fine"}, status: 200
  end


  private

  def get_ipad_ratio original, wanted
    return 1 if wanted.to_i > original
    return wanted.to_f / original.to_f
  end

  def validate_params opts
    return "Missing one of the following parameters: url, width, height" unless opts[:url] && opts[:width] && opts[:height]
    return "Width is invalid" if !/\A\d+\z/.match(opts[:width])
    return "Height is invalid" if !/\A\d+\z/.match(opts[:height])
  end

  def get_random_string
    "#{[*('a'..'z')].sample(12).join}#{Time.new.to_i.to_s}"
  end

end
