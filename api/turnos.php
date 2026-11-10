<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, DELETE');
header('Access-Control-Allow-Headers: Content-Type');
require __DIR__ . '/db.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    if (isset($_GET['paciente_id'])) {
        $stmt = $pdo->prepare("SELECT t.id, t.fecha, t.hora, t.estado, t.especialidad_id, e.nombre AS especialidad, CONCAT(m.nombre,' ',m.apellido) AS medico FROM turnos t JOIN especialidades e ON t.especialidad_id = e.id JOIN medicos m ON t.medico_id = m.id WHERE t.paciente_id = ? ORDER BY t.fecha DESC, t.hora DESC");
        $stmt->execute([$_GET['paciente_id']]);
    } else {
        $stmt = $pdo->query("SELECT t.id, t.fecha, t.hora, t.estado, CONCAT(p.nombre,' ',p.apellido) AS paciente, p.dni AS dni_paciente, CONCAT(m.nombre,' ',m.apellido) AS medico, e.nombre AS especialidad FROM turnos t JOIN pacientes p ON t.paciente_id = p.id JOIN medicos m ON t.medico_id = m.id JOIN especialidades e ON t.especialidad_id = e.id ORDER BY t.fecha DESC, t.hora DESC");
    }
    echo json_encode($stmt->fetchAll());

} elseif ($method === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    $check = $pdo->prepare("SELECT id FROM turnos WHERE medico_id = ? AND fecha = ? AND hora = ?");
    $check->execute([$data['medico_id'], $data['fecha'], $data['hora']]);
    if ($check->fetch()) {
        http_response_code(409);
        echo json_encode(['error' => 'Ese horario ya está reservado.']);
        exit;
    }
    $stmt = $pdo->prepare("INSERT INTO turnos (paciente_id, medico_id, especialidad_id, fecha, hora, estado) VALUES (?, ?, ?, ?, ?, 'confirmado')");
    $stmt->execute([$data['paciente_id'], $data['medico_id'], $data['especialidad_id'], $data['fecha'], $data['hora']]);
    echo json_encode(['ok' => true, 'id' => $pdo->lastInsertId()]);

} elseif ($method === 'DELETE') {
    $data = json_decode(file_get_contents('php://input'), true);
    $stmt = $pdo->prepare("UPDATE turnos SET estado = 'cancelado' WHERE id = ?");
    $stmt->execute([$data['id']]);
    echo json_encode(['ok' => true]);
}
?>