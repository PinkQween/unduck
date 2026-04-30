import { defineConfig } from "vite";
import { VitePWA } from "vite-plugin-pwa";

export default defineConfig({
  plugins: [
    VitePWA({
      registerType: "autoUpdate",
    }),
  ],
  build: {
    rolldownOptions: {
      input: {
        main: "index.html",
        "search-bangs": "src/search-bangs.html",
      },
    },
  }
});
