import Toastify from "toastify-js";
import "toastify-js/src/toastify.css";

type ToastKind = "success" | "error" | "info";

const ICONS: Record<ToastKind, string> = {
  success:
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>',
  error:
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18M6 6l12 12"/></svg>',
  info: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M12 8h.01M11 12h1v4h1"/></svg>',
};

// Toast con el estilo del sitio (usa los tokens de tema, claro y oscuro).
export function showToast(kind: ToastKind, text: string, duration = 4500) {
  const node = document.createElement("div");
  node.className = "ferrum-toast__body";

  const icon = document.createElement("span");
  icon.className = "ferrum-toast__icon";
  icon.innerHTML = ICONS[kind];

  const msg = document.createElement("span");
  msg.textContent = text;

  node.append(icon, msg);

  Toastify({
    node,
    duration,
    gravity: "bottom",
    position: "right",
    close: true,
    stopOnFocus: true,
    className: `ferrum-toast ferrum-toast--${kind}`,
    style: { background: "" },
    ariaLive: kind === "error" ? "assertive" : "polite",
  }).showToast();
}
