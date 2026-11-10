<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
require __DIR__ . '/db.php';

if (isset($_GET['especialidad_id'])) {
    $stmt = $pdo->prepare("SELECT id, nombre, apellido, matricula, especialidad_id FROM medicos WHERE especialidad_id = ? AND activo = 1 ORDER BY apellido");
    $stmt->execute([$_GET['especialidad_id']]);
} else {
    $stmt = $pdo->query("SELECT m.id, m.nombre, m.apellido, m.matricula, m.telefono, m.especialidad_id, e.nombre AS especialidad FROM medicos m JOIN especialidades e ON m.especialidad_id = e.id WHERE m.activo = 1 ORDER BY e.nombre, m.apellido");
}

echo json_encode($stmt->fetchAll());
?>