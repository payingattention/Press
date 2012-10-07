/**
 * jQuery Image Lightbox v1
 * by Jason "Palamedes" Ellis <palamedes[at]rocketmail.com>
 */

$(document).ready(function() {

    $("img.lightbox").click(function() {
        // localize this
        var dis = $(this);
        // get the href
        var source = dis.attr('src');
        // make sure its an image
        var re = /^.*?(.gif|.jpg|.png)$/i;
        var isImage = re.exec(source);
        if (!isImage) {
            // Not an image, don't lightbox it
            return true;
        }

        // okay now load the real image!
        newImage = new Image();
        newImage.id = 'lightboxImage';
        newImage.src = source;

        // Deal with the different browsers
        var position = {
            scrollTop : function () {
                return  window.pageYOffset ||
                    document.documentElement && document.documentElement.scrollTop ||
                    document.body.scrollTop;
            },
            innerHeight : function () {
                return	window.innerHeight ||
                    document.documentElement && document.documentElement.clientHeight ||
                    document.body.clientHeight;
            },
            innerWidth : function () {
                return	window.innerWidth ||
                    document.documentElement && document.documentElement.clientWidth ||
                    document.body.clientWidth;
            }
        }

        // Get the body overflow state
        var overflowState = $('body').css('overflow');

        // Hide the scroll bars on the right
        $('body').css({overflow:"hidden"});

        // Create the lightboxShade element and append to body
        $('<div id="lightboxShade"></div>').appendTo('body');
        // Style the element
        var lightboxShadeCSS = {
            'position' : 'absolute',
            'top' : position.scrollTop() + 'px',
            'left' : '0px',
            'bottom' : 'auto',
            'width' : '100%',
            'height' : position.innerHeight() + 'px',
            'background' : 'black',
            'opacity' : '0.8',
            'display' : 'none',
            'z-index' : '10000',
            'text-align' : 'center',
            'margin' : '0',
            'padding' : '0'
        };
        // Apply the styles
        $('#lightboxShade').css(lightboxShadeCSS);
        // Create the center box
        $('<div id="lightbox"><img id="lightboxImage" /><div class="closeMsg">Click anywhere to close</div></div>').appendTo('body');

        var disClick = function() {
            // animate the destruction of the lightbox itself
            $('#lightbox').animate({
                /*  This closes the lightbox down.. but can be slow so removed for the time being in favor of just fading it out.
                 width: '0px',
                 height: '0px',
                 top: (position.scrollTop() + (position.innerHeight() / 2)) + "px",
                 marginLeft : '0px',
                 */
                opacity: '0'
            }, 500);
            // fade out the lightbox shade
            $('#lightboxShade').fadeOut(1000, function(){
                // make the scroll bars visible again
                $('body').css({'overflow':overflowState});
                // destroy the elements
                $('#lightbox').remove();
                $('#lightboxShade').remove();
            });
        }

        $('#lightboxImage').click(disClick);
        $('#lightboxShade').click(disClick);

        // style the element
        var lightboxCSS = {
            'width' : '1px',
            'height' : '1px',
            'background' : 'white',
            'opacity' : '1',
            'border' : '2px solid black',
            'top' : (position.scrollTop() + (position.innerHeight() / 2)) + 'px',
            'left' : '50%',
            'position' : 'absolute',
            'z-index' : '10001',
            'text-align' : 'center'
        };
        // apply the styles
        $('#lightbox').css(lightboxCSS);

        // style the close text
        var lightboxCloseMsgCSS = {
            'font-family' : 'verdana',
            'font-size' : '9px',
            'color' : 'white',
            'position' : 'absolute',
            'right' : '0px',
            'bottom' : '-11px'
        };
        // apply styles to close text
        $('#lightbox div.closeMsg').css(lightboxCloseMsgCSS);

        // fade the lightbox in -- shade faster!
        $('#lightboxShade').fadeIn(500);

        // Now animate from 1x1 to a loading box
        var initialHeight = 80;
        var initialWidth = 100;
        $('#lightbox').animate({
            'width' : initialWidth + 'px',
            'height' : initialHeight + 'px',
            'paddingTop' : '20px',
            'top' : position.scrollTop() + ((position.innerHeight() / 2) - (initialHeight / 2)) + 'px',
            'marginLeft' : '-' + (initialWidth/2) + 'px'
        }, 300);


        // Test to see if the image is loaded, if it is show it!
        imageLoaded = function() {
            if (newImage.height > 0) {

                imageHeight = newImage.height;
                imageWidth = newImage.width;

                // Is the image bigger than our screen?  Scale it down if it is
                if (imageHeight > imageWidth) {
                    if (imageHeight > position.innerHeight()) {
                        var percentage = ((position.innerHeight()-20) / imageHeight);
                        imageWidth = imageWidth * percentage;
                        imageHeight = imageHeight * percentage;
                    }
                    if (imageWidth > position.innerWidth()) {
                        var newPercentage = ((position.innerWidth()-20) / imageWidth);
                        imageWidth = imageWidth * newPercentage;
                        imageHeight = imageHeight * newPercentage;
                    }
                } else {
                    if (imageWidth > position.innerWidth()) {
                        var percentage = ((position.innerWidth()-20) / imageWidth);
                        imageWidth = imageWidth * percentage;
                        imageHeight = imageHeight * percentage;
                    }
                    if (imageHeight > position.innerHeight()) {
                        var newPercentage = ((position.innerHeight()-20) / imageHeight);
                        imageWidth = imageWidth * newPercentage;
                        imageHeight = imageHeight * newPercentage;
                    }
                }
                $('#lightboxImage').css({"width": imageWidth + "px", "height": imageHeight  + "px"});

                $('#lightboxImage').css("display","none");
                // Resize the white to fit the image!
                $('#lightbox').animate({
                    'width' : imageWidth + 'px',
                    'height' : imageHeight + 'px',
                    'paddingTop' : '0px',
                    'top' : position.scrollTop() + ((position.innerHeight() / 2) - (imageHeight / 2)) + 'px',
                    'marginLeft' : '-' + (imageWidth/2) + 'px'
                }, 500, function() {
                    $('#lightboxImage').attr("src",newImage.src);
                    $('#lightboxImage').css("display","block");
                });

            } else {
                // @TODO What if it never finds the image? Need Max Revs here..
                setTimeout("imageLoaded()", 200);
            }
        }

        // Okay now start waiting for the image to load..
        setTimeout("imageLoaded()", 200);

        return false;

    });
});

/* Changelog

 1.3 to 1.4
 * changed the z-index from 100 to 10000 in order to combat some sites that have higher z-indexes going on.
 * removed the closing animation infavor of a fade out
 * clicking the shade or the box will close the box now
 * added text to the bottom right that says to click anywhere.
 * I also corrected the key:value pairs to meet spec

 */