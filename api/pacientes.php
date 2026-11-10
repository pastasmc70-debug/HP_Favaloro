<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
require __DIR__ . '/db.php';

$q = '%' . ($_GET['q'] ?? '') . '%';
$stmt = $pdo->prepare("SELECT id, dni, nombre, apellido, fecha_nacimiento, obra_social, grupo_sanguineo, alergias, telefono, domicilio FROM pacientes WHERE activo = 1 AND (CONCAT(nombre,' ',apellido) LIKE ? OR dni LIKE ? OR email LIKE ?) ORDER BY apellido LIMIT 10");
$stmt->execute([$q, $q, $q]);
echo json_encode($stmt->fetchAll());
?>