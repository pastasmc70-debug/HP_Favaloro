<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');
require __DIR__ . '/db.php';

$data      = json_decode(file_get_contents('php://input'), true);
$nombre    = trim($data['nombre'] ?? '');
$apellido  = trim($data['apellido'] ?? '');
$dni       = trim($data['dni'] ?? '');
$email     = trim($data['email'] ?? '');
$password  = trim($data['password'] ?? '');
$telefono  = trim($data['telefono'] ?? '');
$fecha_nac = trim($data['fecha_nacimiento'] ?? '');
$sexo      = trim($data['sexo'] ?? 'X');

if (!$nombre || !$apellido || !$dni || !$email || !$password || !$fecha_nac) {
    http_response_code(400);
    echo json_encode(['error' => 'Completá todos los campos obligatorios']);
    exit;
}

// Verificar DNI duplicado
$stmt = $pdo->prepare("SELECT id FROM pacientes WHERE dni = ?");
$stmt->execute([$dni]);
if ($stmt->fetch()) {
    http_response_code(400);
    echo json_encode(['error' => 'Ya existe un paciente con ese DNI']);
    exit;
}

// Verificar email duplicado
$stmt = $pdo->prepare("SELECT id FROM pacientes WHERE email = ?");
$stmt->execute([$email]);
if ($stmt->fetch()) {
    http_response_code(400);
    echo json_encode(['error' => 'Ya existe una cuenta con ese email']);
    exit;
}

// Insertar
$stmt = $pdo->prepare("
    INSERT INTO pacientes (dni, nombre, apellido, fecha_nacimiento, sexo, email, password_hash, telefono, activo)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)
");
$stmt->execute([$dni, $nombre, $apellido, $fecha_nac, $sexo, $email, $password, $telefono]);

echo json_encode([
    'ok'          => true,
    'rol'         => 'paciente',
    'id'          => $pdo->lastInsertId(),
    'nombre'      => $nombre . ' ' . $apellido,
    'dni'         => $dni,
    'obra_social' => null
]);
?>
