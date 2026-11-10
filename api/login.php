<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');
require __DIR__ . '/db.php';

$data  = json_decode(file_get_contents('php://input'), true);
$email = trim($data['email'] ?? '');
$pass  = trim($data['password'] ?? '');
$rol   = trim($data['rol'] ?? '');

if (!$email || !$pass || !$rol) {
    http_response_code(400);
    echo json_encode(['error' => 'Faltan datos']);
    exit;
}

if ($rol === 'medico') {
    $stmt = $pdo->prepare("
        SELECT m.id, m.nombre, m.apellido, m.email, m.password_hash, m.matricula,
               e.nombre AS especialidad
        FROM medicos m
        LEFT JOIN especialidades e ON m.especialidad_id = e.id
        WHERE m.email = ? AND m.activo = 1
    ");
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    if (!$user || $user['password_hash'] !== $pass) {
        http_response_code(401);
        echo json_encode(['error' => 'Email o contraseña incorrectos']);
        exit;
    }

    echo json_encode([
        'ok'          => true,
        'rol'         => 'medico',
        'id'          => $user['id'],
        'nombre'      => $user['nombre'] . ' ' . $user['apellido'],
        'matricula'   => $user['matricula'],
        'especialidad'=> $user['especialidad']
    ]);

} elseif ($rol === 'paciente') {
    $stmt = $pdo->prepare("
        SELECT id, nombre, apellido, email, password_hash, dni, obra_social
        FROM pacientes
        WHERE email = ? AND activo = 1
    ");
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    if (!$user || $user['password_hash'] !== $pass) {
        http_response_code(401);
        echo json_encode(['error' => 'Email o contraseña incorrectos']);
        exit;
    }

    echo json_encode([
        'ok'         => true,
        'rol'        => 'paciente',
        'id'         => $user['id'],
        'nombre'     => $user['nombre'] . ' ' . $user['apellido'],
        'dni'        => $user['dni'],
        'obra_social'=> $user['obra_social']
    ]);

} else {
    http_response_code(400);
    echo json_encode(['error' => 'Rol inválido']);
}
?>
