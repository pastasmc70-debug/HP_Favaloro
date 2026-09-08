/* ═══════════════════════════════════════════
   auth.js
   Lógica de la pantalla única de Login / Registro (index.html)
   Por defecto: login/registro de PACIENTE.
   El botón de la esquina cambia a modo MÉDICO (solo login, sin registro).
   ═══════════════════════════════════════════ */

let currentRole    = 'paciente'; // 'paciente' | 'doctor'
let isRegisterMode = false;

/* Si ya hay sesión activa, saltar directo al panel correspondiente */
function checkLogin() {
    const user = getUser();
    if (user) {
        location.href = user.rol === 'medico' ? 'medico.html' : 'paciente.html';
    }
}

/* Alterna entre modo Paciente (login+registro) y modo Médico (solo login) */
function toggleModoMedico() {
    currentRole = (currentRole === 'paciente') ? 'doctor' : 'paciente';

    const btnIcon    = document.getElementById('medico-btn-icon');
    const btnText    = document.getElementById('medico-btn-text');
    const subtitle   = document.getElementById('auth-subtitle');
    const toggleWrap = document.getElementById('toggle-register-wrap');

    if (currentRole === 'doctor') {
        // Entrar a modo médico: forzamos que sea solo login, sin registro
        isRegisterMode = false;
        btnIcon.className = 'fas fa-user';
        btnText.textContent = 'Soy paciente';
        subtitle.textContent = 'Acceso para médicos';
        toggleWrap.style.display = 'none'; // los médicos no se auto-registran
    } else {
        btnIcon.className = 'fas fa-user-doctor';
        btnText.textContent = 'Acceso médicos';
        subtitle.textContent = 'Portal Digital del Hospital Favaloro';
        toggleWrap.style.display = 'block';
    }

    aplicarModoFormulario();
}

function toggleRegisterMode() {
    if (currentRole === 'doctor') return; // por las dudas, los médicos no registran
    isRegisterMode = !isRegisterMode;
    aplicarModoFormulario();
}

/* Actualiza textos y qué campos se muestran según currentRole + isRegisterMode */
function aplicarModoFormulario() {
    const regFields  = document.getElementById('reg-fields');
    const btn        = document.getElementById('auth-submit-btn');
    const title      = document.getElementById('auth-title');
    const toggleText = document.getElementById('auth-toggle-text');
    const toggleLink = document.getElementById('auth-toggle-link');

    if (currentRole === 'doctor') {
        regFields.style.display = 'none';
        title.textContent = 'Ingreso Médicos';
        btn.innerHTML = '<i class="fas fa-right-to-bracket"></i> Ingresar como médico';
        return;
    }

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
}

function showAuthError(msg) {
    const el = document.getElementById('auth-error');
    document.getElementById('auth-error-msg').textContent = msg;
    el.style.display = 'block';
    setTimeout(() => el.style.display = 'none', 4000);
}

function handleAuth() {
    (currentRole === 'paciente' && isRegisterMode) ? registerUser() : handleLogin();
}

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
        showAuthError(data.error || (rol === 'medico'
            ? 'Email o contraseña incorrectos.'
            : 'Email o contraseña incorrectos. Si sos médico, usá el botón "Acceso médicos".'));
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

    const payload = {
        rol: 'paciente',
        nombre, apellido, dni, fecha_nacimiento: fecha_nac, sexo, telefono, email, password: pass,
        domicilio:       document.getElementById('auth-domicilio').value.trim(),
        obra_social:     document.getElementById('auth-obra-social').value.trim(),
        grupo_sanguineo: document.getElementById('auth-grupo-sanguineo').value,
        alergias:        document.getElementById('auth-alergias').value.trim()
    };

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
