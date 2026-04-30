import { bangs } from "./bang";
import "./global.css";

const app = document.getElementById("app");

if (app) {
  app.innerHTML = `
    <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100vh;">
      <div class="content-container">
        <h1>Search Bangs</h1>
        <div class="search-bangs-container"> 
          <input 
            type="text" 
            class="search-bangs-input"
            placeholder="Type a search bang (e.g. Wikipedia)"
          />
          <div class="search-bangs-list"></div>
        </div>
      </div>
    </div>
  `;

  const input = app.querySelector(".search-bangs-input");
  const list = app.querySelector(".search-bangs-list");

  function normalize(str) {
    return str.toLowerCase().replace(/\s+/g, "");
  }

  function filterBangs(value) {
    const v = normalize(value);

    return bangs.filter((b) => {
      const title = normalize(b.s);
      const domain = normalize(b.d);
      const bang = normalize(b.t);

      return (
        title.includes(v) ||
        domain.includes(v) ||
        bang.includes(v)
      );
    });
  }

  function render(items) {
    list.innerHTML = items
      .map(
        (b) => `
        <div class="search-bang-item-wrapper" data-bang="${b.t}">
          <div class="search-bang-item" data-bang="${b.t}">
            <span class="search-bang-title">Title: ${b.s}</span>
            <span class="search-bang-description">Domain: ${b.d}</span>
          </div>
          <span class="search-bang-item-bang">!${b.t}</span>
        </div>
      `
      )
      .join("");
  }

  // --- Autofill from ?q= ---
  const params = new URLSearchParams(window.location.search);
  const q = params.get("q");

  if (q) {
    input.value = q;
    render(filterBangs(q));
  } else {
    render(bangs);
  }

  // --- Filter as you type ---
  input.addEventListener("input", (e) => {
    const value = e.target.value;
    render(filterBangs(value));

    // optional: keep URL in sync
    const url = new URL(window.location);
    if (value) {
      url.searchParams.set("q", value);
    } else {
      url.searchParams.delete("q");
    }
    window.history.replaceState({}, "", url);
  });

} else {
  console.error("App element not found");
}