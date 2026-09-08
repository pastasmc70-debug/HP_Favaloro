/* ═══════════════════════════════════════════
   common.js
   Utilidades compartidas por index.html, paciente.html y medico.html
   ═══════════════════════════════════════════ */

/* ── Fetch helper ──
   Esta versión NO llama a un servidor real: usa mockApi() (ver mock-api.js),
   que simula las respuestas sin base de datos, para que el sitio funcione
   como estático en GitHub Pages. Los datos arrancan vacíos. */
async function apiFetch(endpoint, options = {}) {
    try {
        return await mockApi(endpoint, options);
    } catch (e) {
        console.error('Error simulado:', e);
        return null;
    }
}

/* ── Sesión ── */
function getUser() {
    try { return JSON.parse(sessionStorage.getItem('fav_user')); }
    catch (e) { return null; }
}

function setUser(data) {
    sessionStorage.setItem('fav_user', JSON.stringify(data));
}

function logout() {
    sessionStorage.removeItem('fav_user');
    location.href = 'index.html';
}

/**
 * Protege una página según el rol requerido.
 * Si no hay sesión, o el rol no coincide, redirige.
 * Devuelve el objeto user si todo está OK.
 */
function requireRole(rolEsperado) {
    const user = getUser();
    if (!user) { location.href = 'index.html'; return null; }
    if (user.rol !== rolEsperado) {
        location.href = user.rol === 'medico' ? 'medico.html' : 'paciente.html';
        return null;
    }
    document.getElementById('userNameDisplay') && (document.getElementById('userNameDisplay').textContent = user.nombre);
    return user;
}

/* ── Notificaciones ── */
function mostrarNotificacion(msg) {
    const t = document.getElementById('toast');
    if (!t) return;
    t.textContent = msg;
    t.style.display = 'block';
    setTimeout(() => t.style.display = 'none', 3500);
}

/* ── Navegación entre "páginas" internas (tabs) de cada panel ── */
function showPage(id, btn) {
    document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.nav-btn').forEach(b => b.classList.remove('active'));
    const page = document.getElementById(id);
    if (page) page.classList.add('active');
    if (btn) btn.classList.add('active');
}
