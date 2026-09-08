/* ═══════════════════════════════════════════
   paciente.js
   Lógica del Panel Paciente (paciente.html)
   ═══════════════════════════════════════════ */

let todosMedicos           = [];
let especialidadesOcupadas = [];

document.addEventListener('DOMContentLoaded', async () => {
    const user = requireRole('paciente');
    if (!user) return;
    document.querySelectorAll('.patient-name').forEach(e => e.textContent = user.nombre.split(' ')[0]);

    initHorarios();
    await cargarEspecialidades();
    await cargarDoctores();
    await cargarTurnosPaciente();
    await cargarStatsPanel();

    showPage('p-inicio', document.querySelector('#nav-paciente .nav-btn'));
});

function initHorarios() {
    const select = document.getElementById('p-hora-turno');
    select.innerHTML = '';
    for (let i = 7; i <= 19; i++) {
        const h = (i < 10 ? '0' : '') + i + ':00';
        select.innerHTML += `<option value="${h}">${h} hs</option>`;
    }
    const hoy = new Date().toISOString().split('T')[0];
    document.getElementById('p-fecha-dia').min   = hoy;
    document.getElementById('p-fecha-dia').value = hoy;
}

/* ═══ ESPECIALIDADES ═══ */

async function cargarEspecialidades() {
    const res = await apiFetch('especialidades.php');
    if (!res || !res.ok) return;
    const data = await res.json();
    const sel  = document.getElementById('p-especialidad');
    sel.innerHTML = '';
    data.forEach(e => sel.innerHTML += `<option value="${e.id}">${e.nombre}</option>`);
}

/* ═══ TURNOS — asignación automática de médico ═══
   El paciente elige especialidad, fecha y hora. El sistema busca,
   entre todos los médicos de esa especialidad, el primero disponible
   en ese horario (sin que el paciente tenga que elegirlo). */

async function cargarTurnosPaciente() {
    const user  = getUser();
    const lista = document.getElementById('listaTurnosPaciente');
    lista.innerHTML = '<p style="color:var(--muted); font-size:0.9rem;">Cargando...</p>';

    const res = await apiFetch(`turnos.php?paciente_id=${user.id}`);
    if (!res || !res.ok) { lista.innerHTML = '<p style="color:var(--muted);">No se pudo cargar.</p>'; return; }

    const turnos = await res.json();
    especialidadesOcupadas = turnos.filter(t => t.estado !== 'cancelado').map(t => parseInt(t.especialidad_id));
    document.getElementById('p-stat-turnos').textContent = turnos.filter(t => t.estado !== 'cancelado').length;

    if (turnos.length === 0) {
        lista.innerHTML = '<p style="color:var(--muted); font-size:0.9rem;">No tenés citas programadas.</p>';
        return;
    }

    lista.innerHTML = turnos.map(t => `
        <div class="turno-item">
            <div>
                <div style="font-weight:700; font-size:0.9rem;">${t.fecha} · ${t.hora ? t.hora.slice(0,5) : ''} hs</div>
                <div style="font-size:0.8rem; color:var(--muted);">${t.especialidad}</div>
                <div style="font-size:0.78rem; color:var(--primary-light);">Dr. ${t.medico}</div>
                <span class="badge badge-green" style="margin-top:4px;">${t.estado.toUpperCase()}</span>
            </div>
            <button class="btn btn-danger btn-sm" onclick="cancelarTurno(${t.id})"><i class="fas fa-trash"></i></button>
        </div>`).join('');
}

async function validarYAgendar() {
    const fecha   = document.getElementById('p-fecha-dia').value;
    const hora    = document.getElementById('p-hora-turno').value;
    const espId   = parseInt(document.getElementById('p-especialidad').value);
    const user    = getUser();
    const alertEl = document.getElementById('alertaTurno');
    const textoEl = document.getElementById('textoAlerta');
    const btn     = document.getElementById('btnConfirmar');

    if (!fecha) { alert('Elegí una fecha válida.'); return; }

    if (especialidadesOcupadas.includes(espId)) {
        textoEl.textContent = 'Ya tenés un turno de esa especialidad agendado.';
        alertEl.style.display = 'block';
        return;
    }

    alertEl.style.display = 'none';
    btn.disabled = true;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Buscando médico disponible...';

    // Traer todos los médicos de la especialidad elegida
    const resMed = await apiFetch(`medicos.php?especialidad_id=${espId}`);
    const candidatos = (resMed && resMed.ok) ? await resMed.json() : [];

    if (candidatos.length === 0) {
        textoEl.textContent = 'No hay médicos disponibles para esa especialidad.';
        alertEl.style.display = 'block';
        restaurarBoton(btn);
        return;
    }

    // Intentar reservar con cada médico candidato hasta encontrar uno libre en ese horario
    for (const medico of candidatos) {
        const res = await apiFetch('turnos.php', {
            method: 'POST',
            body: JSON.stringify({ paciente_id: user.id, medico_id: medico.id, especialidad_id: espId, fecha, hora: hora + ':00' })
        });

        if (!res) continue;
        if (res.status === 409) continue; // ese médico ya tiene ocupado ese horario, probar el siguiente

        const data = await res.json();
        if (res.ok && data.ok) {
            mostrarNotificacion(`Turno confirmado con el Dr./Dra. ${medico.nombre} ${medico.apellido}!`);
            await cargarTurnosPaciente();
            restaurarBoton(btn);
            return;
        }
    }

    textoEl.textContent = 'Ese horario ya está reservado con todos los médicos disponibles. Elegí otro horario.';
    alertEl.style.display = 'block';
    restaurarBoton(btn);
}

function restaurarBoton(btn) {
    btn.disabled = false;
    btn.innerHTML = '<i class="fas fa-check"></i> Confirmar turno';
}

async function cancelarTurno(id) {
    if (!confirm('¿Cancelar este turno?')) return;
    const res = await apiFetch('turnos.php', {
        method: 'DELETE',
        body: JSON.stringify({ id })
    });
    if (res && res.ok) {
        mostrarNotificacion('Turno cancelado exitosamente.');
        await cargarTurnosPaciente();
    }
}

/* ═══ RECETAS ═══ */

async function cargarRecetas() {
    const user  = getUser();
    const lista = document.getElementById('lista-recetas');
    lista.innerHTML = '<p style="color:var(--muted);">Cargando...</p>';

    const res = await apiFetch(`historial.php?paciente_id=${user.id}`);
    if (!res || !res.ok) { lista.innerHTML = '<p style="color:var(--muted);">No se pudo cargar.</p>'; return; }

    const data      = await res.json();
    const conReceta = data.filter(h => h.receta);
    if (conReceta.length === 0) { lista.innerHTML = '<p style="color:var(--muted);">No tenés recetas registradas.</p>'; return; }

    lista.innerHTML = conReceta.map(h => {
        const dias   = Math.floor((new Date() - new Date(h.fecha_consulta)) / 86400000);
        const activa = dias <= 30;
        return `<div class="receta-item ${activa ? 'activa' : 'vencida'}">
            <div>
                <div style="font-weight:700; font-size:0.92rem;">${h.receta}</div>
                <div style="font-size:0.8rem; color:var(--muted); margin-top:2px;">Emitida el ${h.fecha_consulta} · Dr. ${h.medico}</div>
            </div>
            <span class="badge ${activa ? 'badge-green' : 'badge-gray'}">${activa ? 'Activa' : 'Vencida'}</span>
        </div>`;
    }).join('');
}

/* ═══ HISTORIAL ═══ */

async function cargarHistorial() {
    const user  = getUser();
    const lista = document.getElementById('lista-historial');
    lista.innerHTML = '<p style="color:var(--muted);">Cargando...</p>';

    const res = await apiFetch(`historial.php?paciente_id=${user.id}`);
    if (!res || !res.ok) { lista.innerHTML = '<p style="color:var(--muted);">No se pudo cargar.</p>'; return; }

    const data = await res.json();
    if (data.length === 0) { lista.innerHTML = '<p style="color:var(--muted);">No hay registros en tu historial.</p>'; return; }

    lista.innerHTML = data.map(h => `
        <div class="historial-item">
            <div class="historial-header">
                <div class="historial-diagnostico">${h.diagnostico}</div>
                <div class="historial-fecha">${h.fecha_consulta}</div>
            </div>
            <div class="historial-body">
                <p><strong>Médico:</strong> Dr. ${h.medico} · ${h.especialidad}</p>
                ${h.tratamiento ? `<p><strong>Tratamiento:</strong> ${h.tratamiento}</p>` : ''}
                ${h.receta ? `<p><strong>Receta:</strong> ${h.receta}</p>` : ''}
            </div>
        </div>`).join('');
}

/* ═══ STATS PANEL PACIENTE ═══ */

async function cargarStatsPanel() {
    const user = getUser();
    const res  = await apiFetch(`historial.php?paciente_id=${user.id}`);
    if (!res || !res.ok) return;
    const data    = await res.json();
    document.getElementById('p-stat-consultas').textContent = data.length;
    const activas = data.filter(h => h.receta && Math.floor((new Date() - new Date(h.fecha_consulta)) / 86400000) <= 30).length;
    document.getElementById('p-stat-recetas').textContent = activas;
}

/* ═══ DOCTORES (cartilla) ═══ */

async function cargarDoctores() {
    if (todosMedicos.length === 0) {
        const res = await apiFetch('medicos.php');
        if (res && res.ok) todosMedicos = await res.json();
    }

    const filtersEl = document.getElementById('esp-filters');
    if (filtersEl && !filtersEl.dataset.built) {
        filtersEl.dataset.built = '1';
        const esps = [...new Map(todosMedicos.map(m => [m.especialidad_id, {id: m.especialidad_id, nombre: m.especialidad}])).values()]
            .sort((a,b) => a.nombre.localeCompare(b.nombre));
        filtersEl.innerHTML = `<button class="filter-tab active" onclick="filtrarDoctores(null, this)">Todas</button>`;
        esps.forEach(e => filtersEl.innerHTML += `<button class="filter-tab" onclick="filtrarDoctores(${e.id}, this)">${e.nombre}</button>`);
    }
    renderDoctores();
}

function renderDoctores(filtroEsp = null, busq = '') {
    const container = document.getElementById('lista-doctores');
    if (!container) return;
    let medicos = todosMedicos;
    if (filtroEsp) medicos = medicos.filter(m => m.especialidad_id === parseInt(filtroEsp));
    if (busq) {
        const q = busq.toLowerCase();
        medicos = medicos.filter(m => (m.nombre + ' ' + m.apellido).toLowerCase().includes(q) || m.especialidad.toLowerCase().includes(q));
    }
    container.innerHTML = '';
    if (medicos.length === 0) { container.innerHTML = '<p style="color:var(--muted);">No se encontraron médicos.</p>'; return; }
    medicos.forEach(m => {
        container.innerHTML += `
            <div class="doctor-card">
                <div class="doctor-avatar">${m.nombre[0]}${m.apellido[0]}</div>
                <div class="doctor-info">
                    <div class="doctor-nombre">Dr. ${m.nombre} ${m.apellido}</div>
                    <div class="doctor-esp">${m.especialidad}</div>
                    <div class="doctor-mat">${m.matricula}</div>
                </div>
            </div>`;
    });
}

function filtrarDoctores(espId, btn) {
    if (btn) {
        document.querySelectorAll('#esp-filters .filter-tab').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
    }
    const busq = document.getElementById('busqueda-cartilla')?.value || '';
    renderDoctores(espId, busq);
}
