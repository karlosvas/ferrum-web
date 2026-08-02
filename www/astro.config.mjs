// @ts-check
import { defineConfig } from "astro/config";
import tailwindcss from "@tailwindcss/vite";
import vercel from "@astrojs/vercel";
import glsl from "vite-plugin-glsl";

// https://astro.build/config
export default defineConfig({
  adapter: vercel(),
  output: "static",
  vite: {
    plugins: [tailwindcss(), glsl()],
  },
});
