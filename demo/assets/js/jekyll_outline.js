// jekyll_img generates picture tags wrapped within divs
// We move the entire div, not just the picture tag
// If an image does not correspond to a heading, delete it
function position_outline_image(picture, before_id) {
  var img = picture.parentElement;
  var title = document.getElementById(before_id);
  if (title) {
    var parent = title.parentElement;
    parent.insertBefore(img, title);
  } else {
    img.remove();
  }
}

function getElementsByIdPrefix(selectorTag, prefix) {
  var items = [];
  var myPosts = document.getElementsByTagName(selectorTag);
  for (var i = 0; i < myPosts.length; i++) {
    //omitting undefined null check for brevity
    if (myPosts[i].id.lastIndexOf(prefix, 0) === 0)
      items.push(myPosts[i]);
  }
  return items;
}

window.onload = (event) => {
  getElementsByIdPrefix("picture", "outline_").forEach(picture => {
    num = picture.id.substring("outline_".length)
    position_outline_image(picture, `title_${num}`)
  });
}
