<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
require __DIR__ . '/db.php';

$stmt = $pdo->query("SELECT id, nombre FROM especialidades WHERE activa = 1 ORDER BY nombre");
echo json_encode($stmt->fetchAll());
?>