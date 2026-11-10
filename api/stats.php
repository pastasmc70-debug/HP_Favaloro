<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
require __DIR__ . '/db.php';

$consultas     = $pdo->query("SELECT COUNT(*) FROM historial_clinico")->fetchColumn();
$pacientes     = $pdo->query("SELECT COUNT(*) FROM pacientes WHERE activo = 1")->fetchColumn();
$especialidades = $pdo->query("SELECT COUNT(*) FROM especialidades WHERE activa = 1")->fetchColumn();
$stock_bajo    = $pdo->query("SELECT COUNT(*) FROM insumos WHERE stock_actual <= stock_minimo AND activo = 1")->fetchColumn();

echo json_encode([
    'consultas'      => $consultas,
    'pacientes'      => $pacientes,
    'especialidades' => $especialidades,
    'stock_bajo'     => $stock_bajo
]);
?>