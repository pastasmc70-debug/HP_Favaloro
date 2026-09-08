/* ═══════════════════════════════════════════
   mock-api.js
   Backend simulado, 100% en el navegador (sin PHP ni MySQL).
   Reemplaza a la carpeta /api para poder alojar el sitio como
   estático en GitHub Pages. Todos los datos arrancan VACÍOS y
   solo viven en memoria mientras la pestaña esté abierta: al
   recargar la página, todo vuelve a empezar de cero.

   La idea es que la parte visual y los botones sigan funcionando
   (login, alta de turnos, guardar consulta, etc.) pero sin ninguna
   base de datos real detrás.
   ═══════════════════════════════════════════ */

const MOCK_DB = {
    especialidades: [],   // { id, nombre }
    medicos: [],          // { id, nombre, apellido, especialidad_id, especialidad, matricula }
    pacientes: [],        // { id, nombre, apellido, dni, ... }
    turnos: [],           // { id, paciente_id, medico_id, especialidad_id, fecha, hora, estado }
    historial: [],        // { id, paciente_id, medico_id, diagnostico, tratamiento, receta, fecha_consulta }
    insumos: []           // { id, nombre, codigo, categoria, stock_actual, stock_minimo, ... }
};

let MOCK_NEXT_ID = { paciente: 1, turno: 1, historial: 1 };

function mockJsonResponse(data, status = 200) {
    return new Response(JSON.stringify(data), {
        status,
        headers: { 'Content-Type': 'application/json' }
    });
}

/**
 * Simula cada endpoint que antes vivía en /api/*.php.
 * Devuelve un objeto Response real (igual que fetch), así el resto
 * del código (auth.js, paciente.js, medico.js) no necesita cambios.
 */
async function mockApi(endpoint, options = {}) {
    const method = (options.method || 'GET').toUpperCase();
    const [path, queryString] = endpoint.split('?');
    const params = new URLSearchParams(queryString || '');
    let body = {};
    try { body = options.body ? JSON.parse(options.body) : {}; } catch (e) { body = {}; }

    switch (path) {

        /* ── LOGIN: sin base de datos, se acepta cualquier credencial
           completa para poder navegar la demo ── */
        case 'login.php': {
            if (!body.email || !body.password) {
                return mockJsonResponse({ ok: false, error: 'Completá todos los campos.' }, 400);
            }
            const nombre = body.email.split('@')[0];
            return mockJsonResponse({
                ok: true,
                id: 1,
                nombre: nombre.charAt(0).toUpperCase() + nombre.slice(1),
                apellido: '',
                rol: body.rol,
                email: body.email
            });
        }

        /* ── REGISTRO: guarda al paciente en memoria (se pierde al recargar) ── */
        case 'registro.php':
        case 'resgister.php': {
            const nuevo = { id: MOCK_NEXT_ID.paciente++, ...body };
            MOCK_DB.pacientes.push(nuevo);
            return mockJsonResponse({ ok: true });
        }

        case 'especialidades.php':
            return mockJsonResponse(MOCK_DB.especialidades);

        case 'medicos.php': {
            let data = MOCK_DB.medicos;
            const espId = params.get('especialidad_id');
            if (espId) data = data.filter(m => m.especialidad_id === parseInt(espId));
            return mockJsonResponse(data);
        }

        case 'pacientes.php': {
            const q = (params.get('q') || '').toLowerCase();
            const data = q
                ? MOCK_DB.pacientes.filter(p =>
                    `${p.nombre || ''} ${p.apellido || ''}`.toLowerCase().includes(q) ||
                    (p.dni || '').includes(q))
                : MOCK_DB.pacientes;
            return mockJsonResponse(data);
        }

        case 'insumos.php':
            return mockJsonResponse(MOCK_DB.insumos);

        case 'stats.php':
            return mockJsonResponse({
                consultas: MOCK_DB.historial.length,
                pacientes: MOCK_DB.pacientes.length,
                especialidades: MOCK_DB.especialidades.length,
                stock_bajo: MOCK_DB.insumos.filter(i => i.stock_actual <= i.stock_minimo).length
            });

        case 'turnos.php': {
            if (method === 'GET') {
                let data = MOCK_DB.turnos;
                const pacienteId = params.get('paciente_id');
                const medicoId   = params.get('medico_id');
                if (pacienteId) data = data.filter(t => t.paciente_id === parseInt(pacienteId));
                if (medicoId)   data = data.filter(t => t.medico_id === parseInt(medicoId));
                return mockJsonResponse(data);
            }
            if (method === 'POST') {
                const ocupado = MOCK_DB.turnos.some(t =>
                    t.medico_id === body.medico_id && t.fecha === body.fecha &&
                    t.hora === body.hora && t.estado !== 'cancelado');
                if (ocupado) return mockJsonResponse({ ok: false, error: 'Horario ocupado' }, 409);

                const nuevo = {
                    id: MOCK_NEXT_ID.turno++,
                    ...body,
                    estado: 'confirmado',
                    medico: '', especialidad: ''
                };
                MOCK_DB.turnos.push(nuevo);
                return mockJsonResponse({ ok: true, id: nuevo.id });
            }
            if (method === 'DELETE') {
                const t = MOCK_DB.turnos.find(t => t.id === body.id);
                if (t) t.estado = 'cancelado';
                return mockJsonResponse({ ok: true });
            }
            break;
        }

        case 'historial.php': {
            if (method === 'GET') {
                const pacienteId = params.get('paciente_id');
                const data = pacienteId
                    ? MOCK_DB.historial.filter(h => h.paciente_id === parseInt(pacienteId))
                    : MOCK_DB.historial;
                return mockJsonResponse(data);
            }
            if (method === 'POST') {
                const nuevo = { id: MOCK_NEXT_ID.historial++, ...body, medico: '', especialidad: '' };
                MOCK_DB.historial.push(nuevo);
                return mockJsonResponse({ ok: true });
            }
            break;
        }
    }

    return mockJsonResponse({ ok: false, error: 'Endpoint no disponible en la versión estática.' }, 404);
}
