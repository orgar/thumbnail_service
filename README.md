# README

### So what this code do?
The service should fetch the image located at the given url and return a resized version
(based on the given dimensions) in JPEG format.<br />
The image is scaled down to fill the given width and height while retaining the
original aspect ratio and with all of the original image visible. If the requested
dimensions are bigger than the original images, the image doesn’t scale up. If
the proportions of the original image do not match the given width and height,
black padding is added to the image to reach the required size.

### Examples
Given the following image (250x167) located at http://www.example.com/sample.jpg:

No padding (on dimensions with similar aspect ratio as original’s):<br />
GET /thumbnail?url=http://www.example.com/sample.jpg&amp;width=200&amp;height=134

Top + bottom padding:<br />
GET /thumbnail?url=http://www.example.com/sample.jpg&amp;width=200&amp;height=200

Left + right padding:<br />
GET /thumbnail?url=http://www.example.com/sample.jpg&amp;width=300&amp;height=134

Left + right + top + bottom padding (requested dims are larger than original image’s):<br />
GET /thumbnail?url=http://www.example.com/sample.jpg&amp;width=300&amp;height=300

### Ruby version
2.4.1

### Pre installation:
Git, Ruby(2.4.1) and ImageMagick or GraphicsMagick

### Installation:
```
# rvm use 2.4.1
gem install bundle
bundle
```

### Run the server
```
rails s
```

### Unit tests
```
bundle exec rspec
```

### What not implemented yet?
* logger
* tests are partial no mock or stubs implemented
* task for clean the images that created locally
* cache for using the same images again(for bigger scale)
