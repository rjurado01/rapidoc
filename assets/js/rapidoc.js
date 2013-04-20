window.onload = function () { 
  var collapse = '#' + decodeURI( (RegExp(name + '=' + '(.+?)(&|$)').exec(location.search)||[,null])[1] );
  console.log(collapse)
  $(collapse).collapse('show')
}


