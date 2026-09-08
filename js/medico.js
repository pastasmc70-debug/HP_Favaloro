/* ═══════════════════════════════════════════
   medico.js
   Lógica del Panel Médico (medico.html)
   ═══════════════════════════════════════════ */

let filtroCatInsumo = 'todos';
let todosInsumos     = [];
let medicoActual      = null;

document.addEventListener('DOMContentLoaded', async () => {
    const user = requireRole('medico');
    if (!user) return;
    medicoActual = user;

    await cargarInsumosDoctor();
    renderAlertas();
    buildCatFilters();
    await cargarStatsDoctor();

    showPage('d-inicio', document.querySelector('#nav-doctor .nav-btn'));
});

async function cargarStatsDoctor() {
    const res = await apiFetch('stats.php');
    if (!res || !res.ok) return;
    const d = await res.json();
    document.getElementById('d-stat-consultas').textContent      = d.consultas       ?? '—';
    document.getElementById('d-stat-pacientes').textContent      = d.pacientes       ?? '—';
    document.getElementById('d-stat-especialidades').textContent = d.especialidades  ?? '—';
    document.getElementById('d-stat-low').textContent             = d.stock_bajo      ?? '0';
}

/* ═══ INSUMOS ═══ */

async function cargarInsumosDoctor() {
    if (todosInsumos.length === 0) {
        const res = await apiFetch('insumos.php');
        if (res && res.ok) todosInsumos = await res.json();
    }
    renderInsumos();
}

function buildCatFilters() {
    const el = document.getElementById('cat-filters');
    if (!el) return;
    el.innerHTML = `
        <button class="filter-tab active" onclick="setFiltroInsumo('todos', this)">Todos</button>
        <button class="filter-tab" onclick="setFiltroInsumo('medicamento', this)">Medicamentos</button>
        <button class="filter-tab" onclick="setFiltroInsumo('material', this)">Materiales</button>
        <button class="filter-tab" onclick="setFiltroInsumo('equipo', this)">Equipos</button>`;
}

function setFiltroInsumo(cat, btn) {
    filtroCatInsumo = cat;
    document.querySelectorAll('#cat-filters .filter-tab').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    renderInsumos();
}

function renderInsumos(busq = '') {
    const container = document.getElementById('lista-insumos');
    if (!container) return;
    let items = todosInsumos;
    if (filtroCatInsumo !== 'todos') items = items.filter(i => i.categoria === filtroCatInsumo);
    if (busq) {
        const q = busq.toLowerCase();
        items = items.filter(i => i.nombre.toLowerCase().includes(q) || i.codigo.toLowerCase().includes(q));
    }
    container.innerHTML = '';
    if (items.length === 0) { container.innerHTML = '<p style="color:var(--muted);">Sin resultados.</p>'; return; }
    items.forEach(m => {
        const pct        = Math.min(100, Math.round((m.stock_actual / Math.max(m.stock_minimo * 3, 1)) * 100));
        const stockClass = m.stock_actual <= m.stock_minimo ? 'stock-critical' : m.stock_actual <= m.stock_minimo * 1.5 ? 'stock-low' : 'stock-ok';
        const badgeHtml  = m.stock_actual <= m.stock_minimo
            ? `<span class="badge badge-red">Stock crítico</span>`
            : m.stock_actual <= m.stock_minimo * 1.5
                ? `<span class="badge badge-orange">Stock bajo</span>`
                : `<span class="badge badge-green">OK</span>`;
        container.innerHTML += `
            <div class="insumo-card">
                <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:4px;">
                    <div class="insumo-nombre">${m.nombre}</div>${badgeHtml}
                </div>
                <div class="insumo-meta">${m.codigo} · ${m.unidad}</div>
                <div class="insumo-meta">Proveedor: ${m.proveedor}</div>
                <div class="insumo-meta" style="margin-top:3px; color:var(--dark); font-weight:600;">$${parseFloat(m.precio_unitario).toLocaleString('es-AR')}</div>
                <div class="stock-bar"><div class="stock-fill ${stockClass}" style="width:${pct}%"></div></div>
                <div class="insumo-meta" style="margin-top:4px;">Stock: ${m.stock_actual} / mín. ${m.stock_minimo}</div>
            </div>`;
    });
}

function filtrarInsumos() { renderInsumos(document.getElementById('busq-insumos').value); }

function renderAlertas() {
    const container = document.getElementById('d-alertas-stock');
    if (!container) return;
    const bajos = todosInsumos.filter(i => i.stock_actual <= i.stock_minimo * 1.5);
    if (bajos.length === 0) { container.innerHTML = '<p style="color:var(--success); font-weight:600;">Todos los insumos tienen stock adecuado.</p>'; return; }
    container.innerHTML = '';
    bajos.slice(0, 8).forEach(i => {
        const critico = i.stock_actual <= i.stock_minimo;
        container.innerHTML += `
            <div style="display:flex; justify-content:space-between; align-items:center; padding:0.7rem 0; border-bottom:1px solid var(--border);">
                <div>
                    <span style="font-weight:700; font-size:0.9rem;">${i.nombre}</span>
                    <span style="font-size:0.78rem; color:var(--muted); margin-left:8px;">${i.codigo}</span>
                </div>
                <div style="display:flex; align-items:center; gap:10px;">
                    <span style="font-size:0.82rem; color:var(--muted);">Stock: ${i.stock_actual} / mín. ${i.stock_minimo}</span>
                    <span class="badge ${critico ? 'badge-red' : 'badge-orange'}">${critico ? 'Crítico' : 'Bajo'}</span>
                </div>
            </div>`;
    });
}

/* ═══ CITAS DOCTOR ═══ */

async function cargarCitasDoctor() {
    const cont = document.getElementById('listaCitasDoctor');
    cont.innerHTML = '<p style="color:var(--muted);">Cargando...</p>';
    const res = await apiFetch(`turnos.php?medico_id=${medicoActual.id}`);
    if (!res || !res.ok) { cont.innerHTML = '<p style="color:var(--muted);">No se pudo cargar.</p>'; return; }
    const data = await res.json();
    if (data.length === 0) { cont.innerHTML = '<p style="color:var(--muted); font-size:0.9rem;">No hay citas agendadas.</p>'; return; }

    cont.innerHTML = `
        <div class="table-wrap"><table>
            <thead><tr><th>Fecha</th><th>Hora</th><th>Paciente</th><th>Médico</th><th>Especialidad</th><th>Estado</th></tr></thead>
            <tbody>${data.map(t => {
                const color = t.estado === 'confirmado' ? 'badge-green' : t.estado === 'cancelado' ? 'badge-red' : 'badge-orange';
                return `<tr>
                    <td>${t.fecha}</td>
                    <td>${t.hora ? t.hora.slice(0,5) : ''}hs</td>
                    <td><strong>${t.paciente}</strong><br><small style="color:var(--muted);">${t.dni_paciente}</small></td>
                    <td>Dr. ${t.medico}</td>
                    <td>${t.especialidad}</td>
                    <td><span class="badge ${color}">${t.estado.toUpperCase()}</span></td>
                </tr>`;
            }).join('')}
            </tbody>
        </table></div>`;
}

/* ═══ BUSCADOR PACIENTES + PERFIL COMPLETO ═══ */

let ultimosResultadosPacientes = [];

async function buscarPaciente() {
    const q    = document.getElementById('d-busq-paciente').value.trim();
    const cont = document.getElementById('d-resultado-paciente');
    if (!q) { cont.innerHTML = ''; return; }

    const res = await apiFetch(`pacientes.php?q=${encodeURIComponent(q)}`);
    if (!res || !res.ok) { cont.innerHTML = '<p style="color:var(--muted);">No se encontraron pacientes.</p>'; return; }
    const resultados = await res.json();
    if (resultados.length === 0) { cont.innerHTML = '<p style="color:var(--muted);">No se encontraron pacientes.</p>'; return; }

    ultimosResultadosPacientes = resultados;
    cont.innerHTML = '';
    resultados.slice(0, 10).forEach(p => {
        const edad = new Date().getFullYear() - new Date(p.fecha_nacimiento || '1990-01-01').getFullYear();
        cont.innerHTML += `
            <div class="patient-card" id="patient-card-${p.id}">
                <div class="patient-card-header" onclick="togglePerfilPaciente(${p.id})">
                    <div class="doctor-avatar" style="width:50px;height:50px;font-size:1.1rem;">${(p.nombre||'?')[0]}${(p.apellido||'?')[0]}</div>
                    <div style="flex:1;">
                        <div class="patient-card-name">${p.nombre} ${p.apellido}</div>
                        <div style="font-size:0.82rem; color:var(--muted); margin-top:2px;">DNI: ${p.dni} · ${edad} años · ${p.obra_social||'Sin obra social'}</div>
                        <div style="display:flex; gap:0.6rem; flex-wrap:wrap; margin-top:8px;">
                            ${p.grupo_sanguineo ? `<span class="badge badge-red">${p.grupo_sanguineo}</span>` : ''}
                            ${p.alergias ? `<span class="badge badge-orange">Alergias: ${p.alergias}</span>` : ''}
                            <span class="badge badge-blue">${p.telefono||'Sin teléfono'}</span>
                        </div>
                        <div style="font-size:0.8rem; color:var(--muted); margin-top:6px;">${p.domicilio||'Sin domicilio'}</div>
                    </div>
                    <i class="fas fa-chevron-down patient-toggle-icon" id="toggle-icon-${p.id}"></i>
                </div>
                <div class="patient-profile-expand" id="perfil-expand-${p.id}"></div>
            </div>`;
    });
}

async function togglePerfilPaciente(id) {
    const expand = document.getElementById(`perfil-expand-${id}`);
    const icon   = document.getElementById(`toggle-icon-${id}`);
    const abrir  = !expand.classList.contains('open');

    expand.classList.toggle('open', abrir);
    icon.classList.toggle('open', abrir);

    if (abrir && !expand.dataset.loaded) {
        expand.dataset.loaded = '1';
        expand.innerHTML = '<p style="color:var(--muted);">Cargando historial clínico...</p>';
        await renderPerfilCompleto(id, expand);
    }
}

async function renderPerfilCompleto(id, container) {
    const paciente = ultimosResultadosPacientes.find(p => p.id === id);
    const res       = await apiFetch(`historial.php?paciente_id=${id}`);
    const historial = (res && res.ok) ? await res.json() : [];

    container.innerHTML = `
        <div class="profile-section-title"><i class="fas fa-notes-medical"></i> Historial clínico</div>
        <div id="hist-list-${id}">${renderHistorialItems(historial)}</div>

        <div class="profile-section-title"><i class="fas fa-stethoscope"></i> Nueva consulta / diagnóstico</div>
        <div class="consulta-form-grid">
            <div class="ctrl-group full">
                <label class="ctrl-label">Diagnóstico</label>
                <textarea class="ctrl" id="consulta-diagnostico-${id}" placeholder="Ej: Faringitis aguda"></textarea>
            </div>
            <div class="ctrl-group full">
                <label class="ctrl-label">Tratamiento</label>
                <textarea class="ctrl" id="consulta-tratamiento-${id}" placeholder="Indicaciones para el paciente"></textarea>
            </div>
            <div class="ctrl-group full">
                <label class="ctrl-label">Receta (opcional)</label>
                <input type="text" class="ctrl" id="consulta-receta-${id}" placeholder="Ej: Amoxicilina 500mg cada 8hs por 7 días">
            </div>
        </div>
        <div style="display:flex; gap:0.8rem; flex-wrap:wrap; margin-top:0.4rem;">
            <button class="btn btn-primary" onclick="guardarConsulta(${id})"><i class="fas fa-floppy-disk"></i> Guardar consulta</button>
            <button class="btn btn-ghost" id="btn-virtual-${id}" onclick="toggleConsultaVirtual(${id})"><i class="fas fa-video"></i> Iniciar consulta virtual</button>
        </div>

        <div id="video-call-${id}"></div>
    `;
}

function renderHistorialItems(historial) {
    if (!historial || historial.length === 0) {
        return '<p style="color:var(--muted); font-size:0.88rem;">Sin registros previos.</p>';
    }
    return historial.map(h => `
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

async function guardarConsulta(pacienteId) {
    const diagnostico = document.getElementById(`consulta-diagnostico-${pacienteId}`).value.trim();
    const tratamiento = document.getElementById(`consulta-tratamiento-${pacienteId}`).value.trim();
    const receta       = document.getElementById(`consulta-receta-${pacienteId}`).value.trim();

    if (!diagnostico) { alert('Ingresá al menos un diagnóstico.'); return; }

    const res = await apiFetch('historial.php', {
        method: 'POST',
        body: JSON.stringify({
            paciente_id: pacienteId,
            medico_id: medicoActual.id,
            diagnostico, tratamiento, receta,
            fecha_consulta: new Date().toISOString().split('T')[0]
        })
    });

    if (!res || !res.ok) { alert('No se pudo guardar la consulta. Intentá nuevamente.'); return; }

    mostrarNotificacion('Consulta guardada en el historial del paciente.');
    document.getElementById(`consulta-diagnostico-${pacienteId}`).value = '';
    document.getElementById(`consulta-tratamiento-${pacienteId}`).value = '';
    document.getElementById(`consulta-receta-${pacienteId}`).value = '';

    // Refrescar el historial mostrado
    const resHist = await apiFetch(`historial.php?paciente_id=${pacienteId}`);
    const historial = (resHist && resHist.ok) ? await resHist.json() : [];
    document.getElementById(`hist-list-${pacienteId}`).innerHTML = renderHistorialItems(historial);
}

/* ═══ CONSULTA VIRTUAL (interfaz simulada) ═══ */

function toggleConsultaVirtual(pacienteId) {
    const box = document.getElementById(`video-call-${pacienteId}`);
    const btn = document.getElementById(`btn-virtual-${pacienteId}`);
    const paciente = ultimosResultadosPacientes.find(p => p.id === pacienteId);
    const nombrePaciente = paciente ? `${paciente.nombre} ${paciente.apellido}` : 'el paciente';

    if (box.dataset.activa === '1') {
        box.dataset.activa = '';
        box.innerHTML = '';
        btn.innerHTML = '<i class="fas fa-video"></i> Iniciar consulta virtual';
        return;
    }

    box.dataset.activa = '1';
    btn.innerHTML = '<i class="fas fa-video-slash"></i> Cerrar consulta virtual';
    box.innerHTML = `
        <div class="video-call-box">
            <div class="video-status"><span class="dot"></span> Conectado con ${nombrePaciente}</div>
            <div class="video-call-grid">
                <div class="video-tile"><i class="fas fa-user-doctor"></i><span>Vos (médico)</span></div>
                <div class="video-tile"><i class="fas fa-user"></i><span>${nombrePaciente}</span></div>
            </div>
            <div class="video-controls">
                <button class="video-btn" title="Silenciar micrófono"><i class="fas fa-microphone"></i></button>
                <button class="video-btn" title="Apagar cámara"><i class="fas fa-video"></i></button>
                <button class="video-btn end" title="Finalizar llamada" onclick="toggleConsultaVirtual(${pacienteId})"><i class="fas fa-phone-slash"></i></button>
            </div>
        </div>`;
}
