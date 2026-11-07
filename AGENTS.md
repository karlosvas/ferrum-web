# AGENTS.md

Rust Cargo workspace (Rust edition 2024, wgpu 29 / winit 0.30) + an Astro site at the repo root (`src/`, `public/`). The engine is `ferrum-wgpu`; `demo` is the app (native + WASM); `rpi` is Pi sensor firmware; `shared` is wire-format structs; `xtask` is build automation.

## Commands

- Desktop demo: `cargo run -p demo`
- Web WASM build: `cargo xtask web` — wasm-pack compiles `crates/demo` into `public/pkg/` (gitignored). Requires `wasm-pack` installed. `wasm-opt` is deliberately disabled (`package.metadata.wasm-pack`).
- Frontend dev: `pnpm install && pnpm dev` — **pnpm**, not npm. Prettier: `pnpm format:check` / `format:write`.
- Deploy web: `cargo xtask deploy` (requires vercel CLI).
- Pi: `cargo xtask rpi` — `cross` build for `aarch64-unknown-linux-gnu`, needs Docker/Podman. On Windows it recurses into WSL.
- `cargo xtask demo` = build+deploy Pi then run desktop demo.

Gotchas:
- README mentions `cargo xtask run` — that command **does not exist**. Use `cargo xtask demo`.
- xtask loads the **root `.env`** (RPI_USER, RPI_HOST, IP_HOST; Windows: WSL_USER, WSL_DISTRO). Missing vars fail with a clear error.
- `.cargo/config.toml` defines the `xtask` alias.

## WebGPU / WASM quirks

- The engine **requires WebGPU** (compute shader in `equirectangular.wgsl`); WebGL2 is not supported. Native uses Vulkan. `Demo.astro` checks `navigator.gpu.requestAdapter()` before loading `/pkg/demo.js` and shows per-browser enable instructions (Linux Chromium needs `#enable-unsafe-webgpu`).
- After `init()` on wasm, winit throws a "control flow" exception — **expected, not a bug** (handled in `Demo.astro`).
- Web builds swap in lower-res assets via `cfg(target_arch = "wasm32")` (e.g. `res/plant/textures/1024`). Don't upgrade them: browser caps `max_texture_dimension_2d` at 8192 and full-res assets exceed the wasm32 4 GiB address space.
- `demo/build.rs` copies `res/` into OUT_DIR on native only; skipped for wasm32. Windows icon via `winres`.

## Networking split

- Native demo embeds an axum/tokio **WebSocket server**; wasm is a WebSocket **client** (`ws_web.rs`). `rpi` firmware is the server pushing sensor data. These deps are target-gated — native-only code must not leak into wasm-compiled paths.

## Conventions

- Code comments and UI copy are in **Spanish**; identifiers are English. Keep that mix.
- `ferrum-wgpu` is the reusable, published crate (explicit version 0.2.1, not workspace-inherited) and must not depend on `demo`/`rpi`/`shared`.
- License is dual GPL-3.0-only + commercial; `deny.toml` gates dependency licenses — new deps must be in the allow list (`cargo deny check`).
- No test suites exist (`crates/` has no `#[test]`). CI (`.github/workflows/release.yml`) only builds release binaries on `v*` tags plus `cargo audit`; no lint/test gate.

## Web (Astro, repo root)

- Astro 5 + Tailwind 4, Vercel adapter, `output: "static"`. Path alias `@/*` → `./src/*`. `.astro/` types are generated (gitignored).
- `src/pages/resend.ts` is the only server route (`export const prerender = false`) and needs `RESEND_API_KEY` (not in `.env.example`, which only lists SK_STRIPE/PK_STRIPE).
