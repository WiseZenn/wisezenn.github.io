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
    if (!$scope.length) {
      $scope = $(".post article").first();
    }
    if (!$scope.length) return false;

    var $headings = $scope.find("h1, h2, h3, h4, h5");
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

  function initMobileTocDrawer($tocSidebar) {
    if (!$tocSidebar || !$tocSidebar.length) return;

    var hasTocLinks = $tocSidebar.find("a.nav-link").length > 0;
    if (!hasTocLinks) return;

    var inferredZh = (document.documentElement.lang || "").toLowerCase().indexOf("zh") === 0;
    var tocLabel = $tocSidebar.data("mobileLabel") || (inferredZh ? "目录" : "Contents");
    var closeLabel = $tocSidebar.data("mobileCloseLabel") || (inferredZh ? "关闭" : "Close");
    var currentPrefix = $tocSidebar.data("mobileCurrentPrefix") || "";

    if (!$("#mobile-toc-toggle").length) {
      $("body").append(
        '<button id="mobile-toc-toggle" type="button" aria-label="Open table of contents" aria-expanded="false"><span id="mobile-toc-current"></span><span class="mobile-toc-dot"> · </span><span id="mobile-toc-label"></span></button>'
      );
      $("body").append('<div id="mobile-toc-overlay" aria-hidden="true"></div>');
      $("body").append(
        '<aside id="mobile-toc-drawer" aria-hidden="true"><div class="mobile-toc-header"><span id="mobile-toc-header-label"></span><button id="mobile-toc-close" type="button" aria-label="Close table of contents"></button></div><nav id="mobile-toc-content"></nav></aside>'
      );
    }

    var $toggle = $("#mobile-toc-toggle");
    var $overlay = $("#mobile-toc-overlay");
    var $drawer = $("#mobile-toc-drawer");
    var $drawerContent = $("#mobile-toc-content");
    var $toggleCurrent = $("#mobile-toc-current");
    var $toggleLabel = $("#mobile-toc-label");
    var $toggleDot = $toggle.find(".mobile-toc-dot");
    var $headerLabel = $("#mobile-toc-header-label");
    var $closeButton = $("#mobile-toc-close");

    $toggleLabel.text(tocLabel);
    $headerLabel.text(tocLabel);
    $closeButton.text(closeLabel);

    var $scope = $("#markdown-content");
    var $headings = $scope.find("h1, h2, h3, h4, h5");

    function syncDrawerToc() {
      $drawerContent.empty().append($tocSidebar.children().clone(true, true));
    }

    function updateCurrentSectionLabel() {
      if (!$headings.length) {
        $toggleCurrent.text("");
        $toggleDot.hide();
        return;
      }

      var scrollPos = $(window).scrollTop() + 120;
      var currentText = "";

      $headings.each(function () {
        if ($(this).offset().top <= scrollPos) {
          currentText = $(this).text().trim();
        }
      });

      if (currentText) {
        var currentDisplayText = currentPrefix ? currentPrefix + ": " + currentText : currentText;
        $toggleCurrent.text(currentDisplayText);
        $toggleDot.show();
      } else {
        $toggleCurrent.text("");
        $toggleDot.hide();
      }
    }

    function openDrawer() {
      syncDrawerToc();
      $drawer.addClass("open").attr("aria-hidden", "false");
      $overlay.addClass("open").attr("aria-hidden", "false");
      $toggle.attr("aria-expanded", "true");
      $("body").addClass("mobile-toc-open");
    }

    function closeDrawer() {
      $drawer.removeClass("open").attr("aria-hidden", "true");
      $overlay.removeClass("open").attr("aria-hidden", "true");
      $toggle.attr("aria-expanded", "false");
      $("body").removeClass("mobile-toc-open");
    }

    $toggle.off("click.mobileToc").on("click.mobileToc", function () {
      if ($drawer.hasClass("open")) {
        closeDrawer();
      } else {
        openDrawer();
      }
    });

    $overlay.off("click.mobileToc").on("click.mobileToc", closeDrawer);
    $("#mobile-toc-close").off("click.mobileToc").on("click.mobileToc", closeDrawer);

    $drawerContent.off("click.mobileToc").on("click.mobileToc", "a", function () {
      closeDrawer();
    });

    $(document).off("keydown.mobileToc").on("keydown.mobileToc", function (event) {
      if (event.key === "Escape" && $drawer.hasClass("open")) {
        closeDrawer();
      }
    });

    $(window).off("scroll.mobileToc resize.mobileToc").on("scroll.mobileToc resize.mobileToc", function () {
      if (!window.matchMedia("(max-width: 991.98px)").matches) {
        closeDrawer();
        return;
      }
      updateCurrentSectionLabel();
    });

    updateCurrentSectionLabel();
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

    initMobileTocDrawer($tocSidebar);
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
