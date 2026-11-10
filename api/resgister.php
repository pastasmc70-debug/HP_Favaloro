<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');
require __DIR__ . '/db.php';

$data      = json_decode(file_get_contents('php://input'), true);
$nombre    = $data['nombre']    ?? '';
$dni       = $data['dni']       ?? '';
$email     = $data['email']     ?? '';
$password  = $data['password']  ?? '';
$role      = $data['role']      ?? '';
$credencial = $data['credencial'] ?? '';

if ($role === 'doctor') {
    $stmt = $pdo->prepare("SELECT id, nombre, apellido, email FROM medicos WHERE dni = ? AND matricula = ?");
    $stmt->execute([$dni, $credencial]);
    $medico = $stmt->fetch();
    if (!$medico) {
        http_response_code(400);
        echo json_encode(['error' => 'El DNI o la matrícula no corresponden a ningún médico del hospital.']);
        exit;
    }
    $upd = $pdo->prepare("UPDATE medicos SET email = ?, password_hash = ? WHERE id = ?");
    $upd->execute([$email, $password, $medico['id']]);
    $medico['role']        = 'doctor';
    $medico['displayName'] = 'Dr. ' . $medico['nombre'] . ' ' . $medico['apellido'];
    echo json_encode(['ok' => true, 'user' => $medico]);
} else {
    $partes   = explode(' ', trim($nombre));
    $apellido = array_pop($partes);
    $nombreS  = implode(' ', $partes) ?: $apellido;
    try {
        $stmt = $pdo->prepare("INSERT INTO pacientes (dni, nombre, apellido, fecha_nacimiento, sexo, email, password_hash) VALUES (?, ?, ?, '2000-01-01', 'X', ?, ?)");
        $stmt->execute([$dni, $nombreS, $apellido, $email, $password]);
        $id = $pdo->lastInsertId();
        echo json_encode(['ok' => true, 'user' => ['id' => $id, 'nombre' => $nombreS, 'apellido' => $apellido, 'email' => $email, 'role' => 'paciente', 'displayName' => $nombre]]);
    } catch (PDOException $e) {
        http_response_code(400);
        echo json_encode(['error' => 'Ya existe una cuenta con ese email o DNI.']);
    }
}
?>