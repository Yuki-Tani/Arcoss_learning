var fadeTime = 500;

$('#cover').css({
    'height' : $('body').height(),
    'width' : $('body').width()
});
console.log('show');

$(window).on('load',function(){
  $('#page').show();
  $('#cover').fadeOut(fadeTime);
  console.log('fadeOut');
});

$('nav a , #topLink a').bind('click',function(e){
  var pos;
  switch ($(this).parent().attr('class')) {
    case 'home':
      pos = 'index.html'
    break;
    case 'digest':
      pos = 'index.html#main'
    break;
    case 'news':
      pos = 'index.html#sub'
    break;
    case 'top':
      pos = 'index.html#page'
    break;
    default: pos = 'noAction'
  }
  e.preventDefault();
  if(pos!=='noAction'){
  // animation
    $('#cover').css({
      'height' : $('body').height(),
      'width' : $('body').width()
    }).fadeIn(fadeTime,function(){
      window.location.assign(pos);
    }).fadeOut(fadeTime);
  }
});
