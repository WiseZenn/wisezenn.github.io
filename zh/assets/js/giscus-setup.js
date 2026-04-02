function determineGiscusTheme() {
  
    let theme =
      localStorage.getItem("theme") ||
      document.documentElement.getAttribute("data-theme") ||
      "system";

    if (theme === "dark") return "dark";
    if (theme === "light") return "light";

    const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
    return prefersDark ? "dark" : "light";
  
}

function determineGiscusLang() {
  const configuredLang = "auto";
  if (configuredLang && configuredLang.toLowerCase() !== "auto") {
    return configuredLang;
  }

  const pageLang = (document.documentElement.getAttribute("lang") || "").toLowerCase();
  return pageLang.startsWith("zh") ? "zh-CN" : "en";
}

(function setupGiscus() {
  let giscusTheme = determineGiscusTheme();
  let giscusLang = determineGiscusLang();

  let giscusAttributes = {
    src: "https://giscus.app/client.js",
    "data-repo": "WiseZenn/wisezenn.github.io",
    "data-repo-id": "R_kgDORFnK4Q",
    "data-category": "General",
    "data-category-id": "DIC_kwDORFnK4c4C55Fs",
    "data-mapping": "pathname",
    "data-strict": "0",
    "data-reactions-enabled": "1",
    "data-emit-metadata": "0",
    "data-input-position": "bottom",
    "data-theme": giscusTheme,
    "data-lang": giscusLang,
    crossorigin: "anonymous",
    async: true,
  };

  let giscusScript = document.createElement("script");
  Object.entries(giscusAttributes).forEach(([key, value]) =>
    giscusScript.setAttribute(key, value)
  );
  document.getElementById("giscus_thread").appendChild(giscusScript);
})();

