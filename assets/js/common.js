$(document).ready(function () {
  function slugifyHeading(text) {
    return (text || "")
      .toLowerCase()
      .trim()
      .replace(/[^\w\u4e00-\u9fa5\-\s]/g, "")
      .replace(/\s+/g, "-")
      .replace(/-+/g, "-");
  }

  function buildCustomToc($tocSidebar) {
    var $scope = $("#markdown-content");
    if (!$scope.length) return false;

    var $headings = $scope.find("h2, h3, h4, h5");
    if (!$headings.length) return false;

    var usedIds = {};
    var $root = $('<ul class="nav"></ul>');
    var stack = [{ level: 1, $list: $root }];

    $headings.each(function () {
      var $heading = $(this);
      var level = parseInt(this.tagName.charAt(1), 10);

      var id = $heading.attr("id");
      if (!id) {
        var baseId = slugifyHeading($heading.text()) || "section";
        var nextId = baseId;
        var counter = 2;
        while (usedIds[nextId] || document.getElementById(nextId)) {
          nextId = baseId + "-" + counter;
          counter += 1;
        }
        id = nextId;
        $heading.attr("id", id);
      }
      usedIds[id] = true;

      while (stack.length > 1 && level <= stack[stack.length - 1].level) {
        stack.pop();
      }

      while (level > stack[stack.length - 1].level + 1) {
        var $lastLiGap = stack[stack.length - 1].$list.children("li").last();
        if (!$lastLiGap.length) break;
        var $gapList = $('<ul class="nav"></ul>');
        $lastLiGap.append($gapList);
        stack.push({ level: stack[stack.length - 1].level + 1, $list: $gapList });
      }

      if (level > stack[stack.length - 1].level) {
        var $lastLi = stack[stack.length - 1].$list.children("li").last();
        if ($lastLi.length) {
          var $childList = $('<ul class="nav"></ul>');
          $lastLi.append($childList);
          stack.push({ level: level, $list: $childList });
        }
      }

      var $item = $(
        '<li class="nav-item"><a class="nav-link" href="#' +
          id +
          '">' +
          $heading.text() +
          "</a></li>"
      );
      stack[stack.length - 1].$list.append($item);
    });

    $tocSidebar.empty().append($root);
    return true;
  }

  // add toggle functionality to abstract, award and bibtex buttons
  $("a.abstract").click(function () {
    $(this).parent().parent().find(".abstract.hidden").toggleClass("open");
    $(this).parent().parent().find(".award.hidden.open").toggleClass("open");
    $(this).parent().parent().find(".bibtex.hidden.open").toggleClass("open");
  });
  $("a.award").click(function () {
    $(this).parent().parent().find(".abstract.hidden.open").toggleClass("open");
    $(this).parent().parent().find(".award.hidden").toggleClass("open");
    $(this).parent().parent().find(".bibtex.hidden.open").toggleClass("open");
  });
  $("a.bibtex").click(function () {
    $(this).parent().parent().find(".abstract.hidden.open").toggleClass("open");
    $(this).parent().parent().find(".award.hidden.open").toggleClass("open");
    $(this).parent().parent().find(".bibtex.hidden").toggleClass("open");
  });
  $("a").removeClass("waves-effect waves-light");

  // bootstrap-toc
  if ($("#toc-sidebar").length) {
    var $tocSidebar = $("#toc-sidebar");
    var tocMode = $tocSidebar.data("toc-mode");

    if (tocMode === "jekyll") {
      buildCustomToc($tocSidebar);
    } else {
      // remove related publications years from the TOC
      $(".publications h2").each(function () {
        $(this).attr("data-toc-skip", "");
      });
      var navSelector = "#toc-sidebar";
      var $myNav = $(navSelector);
      Toc.init($myNav);
      $("body").scrollspy({
        target: navSelector,
        offset: 100,
      });
    }
  }

  // add css to jupyter notebooks
  const cssLink = document.createElement("link");
  cssLink.href = "../css/jupyter.css";
  cssLink.rel = "stylesheet";
  cssLink.type = "text/css";

  let jupyterTheme = determineComputedTheme();

  $(".jupyter-notebook-iframe-container iframe").each(function () {
    $(this).contents().find("head").append(cssLink);

    if (jupyterTheme == "dark") {
      $(this).bind("load", function () {
        $(this).contents().find("body").attr({
          "data-jp-theme-light": "false",
          "data-jp-theme-name": "JupyterLab Dark",
        });
      });
    }
  });

  // trigger popovers
  $('[data-toggle="popover"]').popover({
    trigger: "hover",
  });
});
