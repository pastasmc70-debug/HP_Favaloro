/* ═══════════════════════════════════════════
   auth.js
   Lógica de la pantalla única de Login / Registro (index.html)
   ═══════════════════════════════════════════ */

let currentRole    = 'doctor';
let isRegisterMode = false;

/* Si ya hay sesión activa, saltar directo al panel correspondiente */
function checkLogin() {
    const user = getUser();
    if (user) {
        location.href = user.rol === 'medico' ? 'medico.html' : 'paciente.html';
    }
}

function setRole(role, btn) {
    currentRole = role;
    document.querySelectorAll('.role-tab').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    actualizarCamposExtra();
}

function toggleRegisterMode() {
    isRegisterMode = !isRegisterMode;
    const regFields  = document.getElementById('reg-fields');
    const btn        = document.getElementById('auth-submit-btn');
    const title      = document.getElementById('auth-title');
    const toggleText = document.getElementById('auth-toggle-text');
    const toggleLink = document.getElementById('auth-toggle-link');

    if (isRegisterMode) {
        regFields.style.display = 'block';
        btn.innerHTML = '<i class="fas fa-user-plus"></i> Registrarse';
        title.textContent = 'Crear Cuenta';
        toggleText.textContent = '¿Ya tenés una cuenta?';
        toggleLink.textContent = 'Iniciá sesión aquí';
    } else {
        regFields.style.display = 'none';
        btn.innerHTML = '<i class="fas fa-right-to-bracket"></i> Ingresar';
        title.textContent = 'Iniciar Sesión';
        toggleText.textContent = '¿No tenés una cuenta?';
        toggleLink.textContent = 'Regístrate aquí';
    }
    actualizarCamposExtra();
}

/* Muestra/oculta los bloques de campos según el rol y el modo (login/registro) */
function actualizarCamposExtra() {
    const credWrap   = document.getElementById('cred-wrap');
    const pacWrap    = document.getElementById('reg-paciente-extra');
    const mostrar    = isRegisterMode;
    credWrap.style.display = (mostrar && currentRole === 'doctor')   ? 'block' : 'none';
    pacWrap.style.display  = (mostrar && currentRole === 'paciente') ? 'block' : 'none';
}

function showAuthError(msg) {
    const el = document.getElementById('auth-error');
    document.getElementById('auth-error-msg').textContent = msg;
    el.style.display = 'block';
    setTimeout(() => el.style.display = 'none', 4000);
}

function handleAuth() { isRegisterMode ? registerUser() : handleLogin(); }

async function handleLogin() {
    const email = document.getElementById('email').value.trim();
    const pass  = document.getElementById('password').value;
    if (!email || !pass) { showAuthError('Completá todos los campos.'); return; }

    const rol = currentRole === 'doctor' ? 'medico' : 'paciente';

    const res = await apiFetch('login.php', {
        method: 'POST',
        body: JSON.stringify({ email, password: pass, rol })
    });

    if (!res) { showAuthError('No se pudo conectar al servidor.'); return; }
    const data = await res.json();

    if (res.ok && data.ok) {
        setUser(data);
        location.href = rol === 'medico' ? 'medico.html' : 'paciente.html';
    } else {
        showAuthError(data.error || 'Email o contraseña incorrectos. Verificá tu rol también.');
    }
}

async function registerUser() {
    const nombre    = document.getElementById('auth-nombre').value.trim();
    const apellido  = document.getElementById('auth-apellido').value.trim();
    const dni       = document.getElementById('auth-dni').value.trim();
    const fecha_nac = document.getElementById('auth-fecha-nac').value;
    const sexo      = document.getElementById('auth-sexo').value;
    const telefono  = document.getElementById('auth-telefono').value.trim();
    const email     = document.getElementById('email').value.trim();
    const pass      = document.getElementById('password').value;

    if (!nombre || !apellido || !dni || !email || !pass || !fecha_nac) {
        showAuthError('Completá todos los campos obligatorios.');
        return;
    }

    const payload = { nombre, apellido, dni, fecha_nacimiento: fecha_nac, sexo, telefono, email, password: pass };

    if (currentRole === 'doctor') {
        payload.rol        = 'medico';
        payload.credencial = document.getElementById('auth-credencial').value.trim();
        if (!payload.credencial) { showAuthError('Ingresá tu matrícula.'); return; }
    } else {
        payload.rol             = 'paciente';
        payload.domicilio       = document.getElementById('auth-domicilio').value.trim();
        payload.obra_social     = document.getElementById('auth-obra-social').value.trim();
        payload.grupo_sanguineo = document.getElementById('auth-grupo-sanguineo').value;
        payload.alergias        = document.getElementById('auth-alergias').value.trim();
    }

    const res = await apiFetch('registro.php', {
        method: 'POST',
        body: JSON.stringify(payload)
    });

    if (!res) { showAuthError('No se pudo conectar al servidor.'); return; }
    const data = await res.json();

    if (res.ok && data.ok) {
        mostrarNotificacion('Registro exitoso! Iniciando sesión...');
        setTimeout(() => {
            document.getElementById('email').value    = email;
            document.getElementById('password').value = pass;
            isRegisterMode = false;
            handleLogin();
        }, 900);
    } else {
        showAuthError(data.error || 'Error al registrarse. El email o DNI ya pueden estar en uso.');
    }
}
