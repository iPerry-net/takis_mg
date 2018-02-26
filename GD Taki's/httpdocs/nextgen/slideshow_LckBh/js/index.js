$(function(){

    var $slides	= $(".slide");
    var currentSlide = 0;

    TweenLite.set($slides.filter(":gt(0)"), {left:"200px"});	
    TweenLite.delayedCall(5, nextSlide);				

    function nextSlide(){					
        TweenLite.to( $slides.eq(currentSlide), 1, {left:"-140px"} );		

        if (currentSlide < $slides.length - 1) {
            currentSlide++;
        }
        else {
            currentSlide = 0;
        }

        TweenLite.fromTo( $slides.eq(currentSlide), 1, {left: "200px"}, {left:"0px"} );
        TweenLite.delayedCall(4, nextSlide);								
    }
});