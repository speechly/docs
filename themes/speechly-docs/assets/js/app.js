function openTab(evt, tabName) {
    var i, tabcontent, tablinks;

    tabcontent = document.getElementsByClassName('code');
    for (i = 0; i < tabcontent.length; i++) {
        if (!tabcontent[i].className.includes(tabName)) {
            tabcontent[i].style.display = "none";
        }
        else {
            tabcontent[i].style.display = "block";
        }
    }

    tablinks = document.getElementsByClassName('tablinks');
    for (i = 0; i < tablinks.length; i++) {
        if (!tablinks[i].className.includes(tabName)) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }
        else {
            tablinks[i].className += " active";
        }
    }
}

const navbarMenu = () => {
  const burger = $(".navbar-burger"),
        menu = $(".navbar-menu");

  burger.click(() => {
    [burger, menu].forEach((el) => el.toggleClass('is-active'));
  });
}

const sidebarAccordion = () => {
  const triggers = $('.trigger');

  if (triggers) {
    triggers.each((idx, el) => {
      var href = el.attributes.getNamedItem('href').nodeValue;
      href = href.slice(1);
      const collapsible = document.getElementById(href);
      new bulmaCollapsible(collapsible);
      collapsible.bulmaCollapsible('collapse');
    });
  }
}

$(() => {
  navbarMenu();
  sidebarAccordion();
  $('img')
    .wrap('<span style="display:inline-block"></span>')
    .css('display', 'block')
    .parent()
    .zoom({'magnify':0.4, 'on':'click'});
  $('.navbar-logo').trigger('zoom.destroy');
  $('.no-zoom').trigger('zoom.destroy');
});
