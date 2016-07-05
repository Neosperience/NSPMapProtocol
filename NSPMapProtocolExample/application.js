//# sourceURL=application.js

App.onLaunch = function(options) {
    var page = createPage();
    navigationDocument.pushDocument(page);
}

var createPage = function() {

  var page = `<?xml version="1.0" encoding="UTF-8" ?>
    <document>
      <divTemplate>
        <img src="nspmap://?t=h&amp;ll=45.4654,9.1859&amp;spn=2,2&amp;w=600&amp;h=600&amp;p=45.4654,9.1859&amp;p=45.1404,10.0326" style="tv-position: center; tv-align: center" width="600" height="600" />
      </divTemplate>
    </document>`;

  var parser = new DOMParser();
  var pageDoc = parser.parseFromString(page, "application/xml");
  return pageDoc;

}
